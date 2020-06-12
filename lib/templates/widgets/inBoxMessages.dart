import 'dart:io';
import 'package:belafrikapp/models/message.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:belafrikapp/templates/widgets/infoSurConv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {

  String nom, imgUrl, idExp, idDest, emailDest, bloquE;
  int nbreMsgNonLis;
  Messages({this.nom, this.imgUrl, this.idDest,
    this.idExp, this.nbreMsgNonLis, this.emailDest});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  void initState() {
    super.initState();
    if (widget.nbreMsgNonLis >= 1) {
      onreadMsg();
    }
    Firestore.instance.collection('utilisateurs')
        .document(widget.idExp).collection('bloque')
        .document('${widget.idExp}${widget.idDest}')
        .get().then((doc) => doc.exists
        ? widget.bloquE = 'bloqué'
        : widget.bloquE = '');
  }

  Future<void> onreadMsg() async {
    await ServiceBDD(idExp: widget.idExp, idDest: widget.idDest).msgLis();
  }

  File image;

  @override
  Widget build(BuildContext context) {
    final utilisateur = Provider.of<Utilisateur>(context);
    TextEditingController messageController = TextEditingController();

    return StreamProvider<List<Message>>.value(
        value: ServiceBDD(idExp: widget.idExp, idDest: widget.idDest).messages,
        child: StreamBuilder<DonnEesUtil>(
            stream: ServiceBDD(idUtil: utilisateur.idUtil).donnEesUtil,
            builder: (context, snapshot) {

                final donnEeUtil = snapshot.data;
                List<Message> messageList = Provider.of<List<Message>>(context) ?? [];

                //obtenir l'image de la galery
                Future<void> envoiImage(ImageSource source) async {
                  File imageSelectionEe = await ImagePicker.pickImage(source: source);
                  setState(() {
                    this.image = imageSelectionEe;
                    showDialog(context: context, builder: (_) => SimpleDialog(
                      contentPadding: EdgeInsets.zero,
                      children: <Widget>[
                        Image.file(this.image),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              FlatButton(
                                color:Colors.redAccent,
                                child: Text('Envoyer la photo', style: TextStyle(color: Colors.white),),
                                onPressed: ()async {
                                  ProgressDialog pr = ProgressDialog(context);
                                  pr = ProgressDialog(
                                      context,type: ProgressDialogType.Normal,
                                      isDismissible: false
                                  );
                                  pr.style(

                                      borderRadius: 10.0,
                                      backgroundColor: Colors.white,
                                      progressWidget: CircularProgressIndicator(),
                                  );
                                  await pr.show();
                                  //Eregistrer image sur Cloud Storage
                                  StorageReference reference = FirebaseStorage.instance.ref()
                                      .child('${donnEeUtil.nomUtil}${widget.idExp}.png');
                                  StorageUploadTask uploadTask = reference.putFile(image);
                                  StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
                                  String urlImg = await taskSnapshot.ref.getDownloadURL();
                                  await ServiceBDD().envoyezMsg(
                                      donnEeUtil.nomUtil, donnEeUtil.emailUtil, donnEeUtil.photoUrl,
                                      widget.idExp, widget.idDest, widget.nom, widget.emailDest,
                                      widget.imgUrl, '', urlImg);
                                  setState(() => Navigator.pop(context));
                                  await pr.hide();
                                }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ));
                  });
                }
                //Methode pour envoyer un message
                Future<void> sendMsg() async {
                  if (messageController.text.length > 0) {
                    ProgressDialog pr = ProgressDialog(context);
                    pr = ProgressDialog(
                      context,type: ProgressDialogType.Normal,
                      isDismissible: false,
                    );
                    pr.style(
                      backgroundColor: Colors.white,
                      progressWidget: CircularProgressIndicator(),
                    );
                    await pr.show();
                    await ServiceBDD().envoyezMsg(
                        donnEeUtil.nomUtil, donnEeUtil.emailUtil, donnEeUtil.photoUrl,
                        widget.idExp, widget.idDest, widget.nom, widget.emailDest,
                        widget.imgUrl, messageController.text, '');
                    await pr.hide();
                    messageController.clear();
                  }
                }
                return Scaffold(
                  backgroundColor: Colors.grey[200],
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.black),
                    title: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(widget.imgUrl),
                        ),
                        SizedBox(width: 10.0,),
                        Expanded(
                          child: Text(
                            widget.nom,
                            maxLines: 1,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.black),
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => InfoSurConv(
                              idDest: widget.idDest,
                              idExp: widget.idExp,
                              emailDest: widget.emailDest,
                              imgUrlDest: widget.imgUrl,
                              nomDest: widget.nom,
                              nbreMsgTotal: messageList.length,
                            )))
                      )
                    ],
                  ),
                  body: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: messageList.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            //déclaration et affectation de nos variables clés
                            final dateDeFirestore = messageList[index].timestamp.toDate();
                            String date = DateFormat.MMMd().format(dateDeFirestore);
                            String heure = DateFormat.jm().format(dateDeFirestore);
                            bool cMoi = messageList[index].idExp == utilisateur.idUtil;
                            bool contientMsg = messageList[index].msg != '';

                            return Container(
                              child: Column(
                                crossAxisAlignment: cMoi
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: cMoi
                                        ? EdgeInsets.only(
                                            top: 4.0, right: 8.0, left: 50.0,)
                                        : EdgeInsets.only(
                                            top: 4.0, right: 50.0, left: 8.0),
                                    child: Material(
                                      color: cMoi
                                          ? Colors.redAccent
                                          : Colors.red[100],
                                      borderRadius: BorderRadius.circular(10.0),
                                      elevation: 4.0,
                                      child: cMoi ? GestureDetector(
                                        onLongPress: () => showDialog(context: context,
                                            builder: (context) => SimpleDialog(
                                              contentPadding: EdgeInsets.all(8.0),
                                              children: <Widget>[
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        showDialog(context: context, builder: (_) => AlertDialog(
                                                          title: Text('Supprimer le message ?'),
                                                          content: Text('Ce message sera supprimé pour vous. '
                                                              '${widget.nom} pourra encore le voir'),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              onPressed: () {
                                                                setState(() => Navigator.pop(context));
                                                                setState(() => Navigator.pop(context));
                                                              },
                                                              child: Text('ANNULER'),
                                                            ),
                                                            FlatButton(
                                                              onPressed: () {
                                                                setState(() => Navigator.pop(context));
                                                                setState(() => Navigator.pop(context));
                                                                ServiceBDD().sprmerMsgPourVous(widget.idExp, widget.idDest,
                                                                    messageList[index].idMsg);
                                                              },
                                                              child: Text('SUPPRIMER'),
                                                            )
                                                          ],
                                                        ));
                                                      });
                                                    },
                                                    child: Text(
                                                        'Supp. le message pour vous',
                                                        style: Theme.of(context).textTheme.title)),
                                                SizedBox(height: 10.0,),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        showDialog(context: context, builder: (_) =>
                                                            AlertDialog(
                                                              title: Text('Supprimer pour tous ?'),
                                                              content: Text('Ce message sera supprimé pour tous. '
                                                                  '${widget.nom} et vous pourront plus le voir'),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  onPressed: () {
                                                                    setState(() => Navigator.pop(context));
                                                                    setState(() => Navigator.pop(context));
                                                                  },
                                                                  child: Text('ANNULER'),
                                                                ),
                                                                FlatButton(
                                                                  onPressed: () {
                                                                    setState(() => Navigator.pop(context));
                                                                    setState(() => Navigator.pop(context));
                                                                    ServiceBDD().sprmerMsgPourTous(widget.idExp, widget.idDest,
                                                                        messageList[index].idMsg);
                                                                  },
                                                                  child: Text('SUPPRIMER'),
                                                                )
                                                              ],
                                                            ));
                                                      });
                                                      },
                                                    child: Text(
                                                        'Supp. le message pour tous',
                                                        style: Theme.of(context).textTheme.title,
                                                    ))
                                              ],
                                            )),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[
                                              contientMsg ? Text(
                                                messageList[index].msg,
                                                style: Theme.of(context).textTheme.body2.copyWith(
                                                    color: Colors.white),
                                              ) : Container(
                                                height: 200.0,
                                                width: 200.0,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  color: Colors.grey
                                                ),
                                                child: Container(
                                                  height: 200.0,
                                                  width: 200.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      image: DecorationImage(
                                                        image: NetworkImage(messageList[index].msgImage),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                ),
                                              ),
                                              SizedBox(height: 10.0,),
                                              Text(
                                                '$date, $heure',
                                                style: Theme.of(context).textTheme.caption.copyWith(
                                                    color: Colors.white
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ) : GestureDetector(
                                          onLongPress: () => showDialog(context: context, builder: (_) => AlertDialog(
                                            title: Text('Supprimer le message ?'),
                                            content: Text(
                                                'Ce message sera supprimé pour vous. '
                                                    '${widget.nom} pourra encore le voir'),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () => setState(() => Navigator.pop(context)),
                                                child: Text('ANNULER'),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  setState(() => Navigator.pop(context));
                                                  ServiceBDD().sprmerMsgPourVous(widget.idExp, widget.idDest,
                                                      messageList[index].idMsg);
                                                },
                                                child: Text('SUPPRIMER'),
                                              )
                                            ],
                                          )),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                contientMsg ? Text(
                                                  messageList[index].msg,
                                                  style: Theme.of(context).textTheme.body2,
                                                ) : Container(
                                                  height: 200.0,
                                                  width: 200.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      color: Colors.grey
                                                  ),
                                                  child: Container(
                                                      height: 200.0,
                                                      width: 200.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        image: DecorationImage(
                                                          image: NetworkImage( messageList[index].msgImage),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                  ),
                                                ),
                                                SizedBox(height: 10.0,),
                                                    Text(
                                                      '$date, $heure',
                                                      style: Theme.of(context).textTheme.caption,
                                                    )
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      widget.bloquE != 'bloqué' ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey, width: 1.0)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Tapez un message",
                                      border: InputBorder.none,
                                    ),
                                    maxLines: 3,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    controller: messageController,
                                  ),
                                ),
                              ),
                              Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.redAccent),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => sendMsg(),
                                  )),
                              Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.redAccent),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        envoiImage(ImageSource.gallery),
                                  )
                              )
                            ],
                          ),
                        ),
                      ) : Container(
                        child: Center(
                          child: Text('Vous aviez été bloqué'),
                        ),
                      ),
                    ],
                  ),
                );
              }
              ),
        );
  }
}

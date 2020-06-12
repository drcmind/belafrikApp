import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class InfoSurConv extends StatefulWidget {
  String idExp, idDest, imgUrlDest, nomDest, emailDest;
  int nbreMsgTotal;
  InfoSurConv({this.idExp, this.idDest, this.nomDest,
    this.emailDest, this.imgUrlDest, this.nbreMsgTotal});
  @override
  _InfoSurConvState createState() => _InfoSurConvState();
}

class _InfoSurConvState extends State<InfoSurConv> {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserBlockE>.value(
      value: ServiceBDD(idExp: widget.idExp, idDest: widget.idDest).blockdata,
      child: StreamBuilder(
        stream: ServiceBDD(idExp: widget.idExp, idDest: widget.idDest).mesMessages,
        builder: (context, snapshotMesMessages){
          return StreamBuilder(
              stream: ServiceBDD(idExp: widget.idExp, idDest: widget.idDest).nbreMesMsgImg,
              builder: (context, snapshotNbreMesMsgImg){
                return StreamBuilder(
                    stream: ServiceBDD(idExp: widget.idExp, idDest: widget.idDest).nbreSesMsgImg,
                    builder: (context, snapshotNbreSesMsgImg){
                      if(!snapshotNbreSesMsgImg.hasData){
                        return Scaffold(
                            body: Container(
                                child: Center(
                                    child: Text('Chargement...')
                                )
                            )
                        );
                      }else{
                        //Calcul pour les données de la conversation
                        int nbreMesMsgImg = snapshotNbreMesMsgImg.data.documents.length;
                        int mesMsg = snapshotMesMessages.data.documents.length;
                        int nbreSesMsgImg = snapshotNbreSesMsgImg.data.documents.length;
                        int nbreMesMsgTxt = mesMsg - nbreMesMsgImg;
                        int sesMsg = widget.nbreMsgTotal - mesMsg;
                        int nbreSesMsgTxt = sesMsg - nbreSesMsgImg;
                        final userBlock = Provider.of<UserBlockE>(context) ?? UserBlockE(isBlockE: '');
                        return Scaffold(
                          backgroundColor: Colors.grey[200],
                          appBar: AppBar(
                            backgroundColor: Colors.white,
                            iconTheme: IconThemeData(color: Colors.black),
                            title: Text(
                              'Informations sur la Conversation',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          body: widget.nbreMsgTotal > 0 ? SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10.0,),
                                Container(
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(widget.imgUrlDest),
                                        ),
                                        SizedBox(height: 5.0,),
                                        Text(
                                          widget.nomDest,
                                          style: Theme.of(context).textTheme.title,
                                        ),
                                        Text(
                                          '${widget.emailDest}',
                                          style: Theme.of(context).textTheme.subtitle,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'L\'activité de notre conversation '
                                          'avec ${widget.nomDest} contient ${widget.nbreMsgTotal} '
                                          'Message(s) au total',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.subhead.copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  color: Colors.white,
                                  child: DataTable(
                                    columns: [
                                      DataColumn(label: Text(
                                          'Vous',
                                          style: Theme.of(context).textTheme.subhead.copyWith(
                                              color: Colors.black, fontWeight: FontWeight.bold
                                          )
                                      )),
                                      DataColumn(label: Text(
                                          '${widget.nomDest}',
                                          maxLines: 1,
                                          style: Theme.of(context).textTheme.subhead.copyWith(
                                              color: Colors.black, fontWeight: FontWeight.bold
                                          )
                                      ))
                                    ],
                                    rows: [
                                      DataRow(cells: [
                                        DataCell(Text('$nbreMesMsgTxt Message(s) text(s)')),
                                        DataCell(Text('$nbreSesMsgTxt Message(s) text(s)'))
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('$nbreMesMsgImg Message(s) image(s)')),
                                        DataCell(Text('$nbreSesMsgImg Message(s) image(s)'))
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text(
                                          '$mesMsg Msg(s) au total',
                                          style: Theme.of(context).textTheme.body2,
                                        )),
                                        DataCell(Text(
                                          '$sesMsg Msg(s) au total',
                                          style: Theme.of(context).textTheme.body2,
                                        )),
                                      ])
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Container(
                                  padding: EdgeInsets.all(16.0),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      userBlock.isBlockE == 'bloqué'
                                          ? GestureDetector(
                                          onTap: () => showDialog(context: context, builder: (_)
                                          => AlertDialog(
                                            content: Text('Voulez-vous débloquer ${widget.nomDest} ?'),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () => setState(() => Navigator.pop(context)),
                                                child: Text('ANNULER'),
                                              ),
                                              FlatButton(
                                                onPressed: () async {
                                                  setState(() => Navigator.pop(context));
                                                  ProgressDialog pr = ProgressDialog(context);
                                                  pr = ProgressDialog(
                                                    context,type: ProgressDialogType.Normal,
                                                    isDismissible: false,
                                                  );
                                                  pr.style(
                                                    message: 'le déblockage encours...',
                                                    backgroundColor: Colors.white,
                                                    progressWidget: CircularProgressIndicator(),
                                                  );
                                                  await pr.show();
                                                  await ServiceBDD(idExp: widget.idExp, idDest:widget.idDest)
                                                      .deblockE();
                                                  await pr.hide();
                                                  setState(() => Navigator.pop(context));
                                                },
                                                child: Text('DEBLOQUER'),
                                              )
                                            ],
                                          )),
                                          child: Text('Débloquer ${widget.nomDest}')
                                      )
                                          : GestureDetector(
                                        onTap: () => showDialog(context: context, builder: (_)
                                        => AlertDialog(
                                          content: Text('Voulez-vous bloquer ${widget.nomDest} ?'),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () => setState(() => Navigator.pop(context)),
                                              child: Text('ANNULER'),
                                            ),
                                            FlatButton(
                                              onPressed: () async {
                                                setState(() => Navigator.pop(context));
                                                ProgressDialog pr = ProgressDialog(context);
                                                pr = ProgressDialog(
                                                  context,type: ProgressDialogType.Normal,
                                                  isDismissible: false,
                                                );
                                                pr.style(
                                                  message: 'le blockage encours...',
                                                  backgroundColor: Colors.white,
                                                  progressWidget: CircularProgressIndicator(),
                                                );
                                                await pr.show();
                                                await ServiceBDD(idExp: widget.idExp, idDest:widget.idDest)
                                                    .blockE();
                                                await pr.hide();
                                              },
                                              child: Text('BLOQUER'),
                                            )
                                          ],
                                        )),
                                        child: Text('Bloquer ${widget.nomDest}'),
                                      ),
                                      Divider(height: 20.0),
                                      GestureDetector(
                                        onTap: () => showDialog(context: context, builder: (_)
                                        => AlertDialog(
                                          title: Text('Supp. la conversation ?'),
                                          content: Text('Cette conversation sera '
                                              'supprimée de votre boite de reception. '
                                              '${widget.nomDest} '
                                              'pourra encore la voir'),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () => setState(() => Navigator.pop(context)),
                                              child: Text('ANNULER'),
                                            ),
                                            FlatButton(
                                              onPressed: () async {
                                                setState(() => Navigator.pop(context));
                                                await ServiceBDD().supprimerConversation(widget.idExp,
                                                    widget.idDest);
                                                setState(() => Navigator.pop(context));
                                                setState(() => Navigator.pop(context));
                                              },
                                              child: Text('SUPPRIMER'),
                                            )
                                          ],
                                        )),
                                        child: Text(
                                            'Supprimer cette conversation'
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ): Container(
                            child: Center(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 50.0,),
                                    Icon(Icons.cloud_off, size: 50.0),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'Veillez démarrer une conversation avec '
                                            '${widget.nomDest} pour voir l\'activité de la discussion',
                                        style: Theme.of(context).textTheme.title,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    MaterialButton(
                                      color: Colors.redAccent,
                                      child: Text(
                                        'DEMARRER LA CONVERSATION',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                )
                            ),
                          ),
                        );
                      }
                    });
              });
        }),
    );
  }
}

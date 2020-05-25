import 'package:belafrikapp/models/message.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  String nom, imgUrl, idExp, idDest, idMsg;
  Messages({this.nom, this.imgUrl, this.idDest, this.idExp, this.idMsg});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  @override
  void initState() {
    super.initState();
    if(widget.idMsg == 'message déjà vu'){
      return null;
    }else{
      onreadMsg();
    }
  }

  onreadMsg() async {
    await ServiceBDD(idExp: widget.idExp,
        idDest: widget.idDest, idMsg: widget.idMsg).msgLis();
  }

  @override
  Widget build(BuildContext context) {

    final utilisateur = Provider.of<Utilisateur>(context);
    TextEditingController messageController = TextEditingController();
    ScrollController scrollController = ScrollController();
    String msgTxt;

     return StreamProvider<List<Message>>.value(
       value: ServiceBDD(idExp: widget.idExp, idDest: widget.idDest).messages,
       child: StreamBuilder<DonnEesUtil>(
           stream: ServiceBDD(idUtil: utilisateur.idUtil).donnEesUtil,
           builder: (context, snapshot){

             final donnEeUtil = snapshot.data;
             List<Message> messageList = Provider.of<List<Message>>(context) ?? [];

             sendMsg() async {
               if(messageController.text.length > 0){
                 await ServiceBDD()
                     .envoyezMsg(donnEeUtil.nomUtil, donnEeUtil.photoUrl,
                     widget.idExp, widget.idDest, widget.nom,
                     widget.imgUrl, messageController.text);
                 messageController.clear();
               }
             }

             return Scaffold(
               backgroundColor: Colors.grey[200],
               appBar: AppBar(
                 backgroundColor: Colors.white,
                 iconTheme: IconThemeData(
                     color: Colors.black
                 ),
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
               ),
               body: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Expanded(
                     child: ListView.builder(
                       itemCount: messageList.length,
                       itemBuilder: (context, index){

                         final dateDeFirestore = messageList[index].timestamp.toDate();
                         String date = DateFormat.MMMd().format(dateDeFirestore);
                         String heure = DateFormat.jm().format(dateDeFirestore);

                         return Container(
                           child: Column(
                             crossAxisAlignment:
                             messageList[index].idExp == utilisateur.idUtil
                                 ? CrossAxisAlignment.end
                                 : CrossAxisAlignment.start,
                             children: <Widget>[
                               Padding(
                                 padding: messageList[index].idExp == utilisateur.idUtil
                                     ? EdgeInsets.only(top: 4.0, right: 8.0, left: 50.0)
                                     : EdgeInsets.only(top: 4.0, right: 50.0, left: 8.0),
                                 child: Material(
                                   color: messageList[index].idExp == utilisateur.idUtil
                                       ? Colors.redAccent : Colors.red[100],
                                   borderRadius: BorderRadius.circular(10.0),
                                   elevation: 4.0,
                                   child: messageList[index].idExp == utilisateur.idUtil ? GestureDetector(
                                     onLongPress: () => showDialog(context: context, builder: (context)
                                     => SimpleDialog(
                                       contentPadding: EdgeInsets.all(8.0),
                                       children: <Widget>[
                                         Text('Copier le text du message'),
                                         GestureDetector(
                                             onTap: (){
                                               Navigator.pop(context);
                                               showDialog(context: context, builder: (_)
                                               => AlertDialog(
                                                 contentPadding: EdgeInsets.all(8.0),
                                                 title: Text('Supprimer le message ?'),
                                                 content: Text('Ce message sera supprimé pour vous. '
                                                     '${widget.nom} '
                                                     'pourra encore le voir'),
                                                 actions: <Widget>[
                                                   FlatButton(
                                                     onPressed: () => Navigator.pop(context),
                                                     child: Text('ANNULER'),
                                                   ),
                                                   FlatButton(
                                                     onPressed: (){
                                                       Navigator.pop(_);
                                                       ServiceBDD()
                                                           .sprmerMsgPourVous(widget.idExp, widget.idDest,
                                                           messageList[index].idMsg);
                                                     },
                                                     child: Text('SUPPRIMER'),
                                                   )
                                                 ],
                                               ));
                                             },
                                             child: Text('Supprimer le message pour vous')),
                                         GestureDetector(
                                             onTap: (){
                                               Navigator.pop(context);
                                               showDialog(context: context, builder: (_)
                                               => AlertDialog(
                                                 contentPadding: EdgeInsets.all(8.0),
                                                 title: Text('Supprimer le message ?'),
                                                 content: Text('Ce message sera supprimé pour tous. '
                                                     '${widget.nom} '
                                                     'pourra plus le voir'),
                                                 actions: <Widget>[
                                                   FlatButton(
                                                     onPressed: () => Navigator.pop(context),
                                                     child: Text('ANNULER'),
                                                   ),
                                                   FlatButton(
                                                     onPressed: (){
                                                       Navigator.pop(context);
                                                       ServiceBDD()
                                                           .sprmerMsgPourTous(widget.idExp, widget.idDest,
                                                           messageList[index].idMsg);
                                                     },
                                                     child: Text('SUPPRIMER'),
                                                   )
                                                 ],
                                               ));
                                             },
                                           child: Text('Supprimer le message pour tous'))
                                       ],
                                     )),
                                     child: Container(
                                       padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                       child: Column(
                                         crossAxisAlignment : CrossAxisAlignment.end,
                                         children: <Widget>[
                                           Text(
                                             messageList[index].msg,
                                             style: Theme.of(context).textTheme.body2.copyWith(
                                                 color: Colors.white
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
                                     onLongPress: () => showDialog(context: context, builder: (_)
                                     => SimpleDialog(
                                       contentPadding: EdgeInsets.all(8.0),
                                       children: <Widget>[
                                         Text('Copier le text du message'),
                                         GestureDetector(
                                             onTap: (){
                                               Navigator.pop(context);
                                               showDialog(context: context, builder: (_)
                                               => AlertDialog(
                                                 contentPadding: EdgeInsets.all(8.0),
                                                 title: Text('Supprimer le message ?'),
                                                 content: Text('Ce message sera supprimé pour vous. '
                                                     '${widget.nom} '
                                                     'pourra encore le voir'),
                                                 actions: <Widget>[
                                                   FlatButton(
                                                     onPressed: () => Navigator.pop(context),
                                                     child: Text('ANNULER'),
                                                   ),
                                                   FlatButton(
                                                     onPressed: (){
                                                       Navigator.pop(context);
                                                       ServiceBDD()
                                                           .sprmerMsgPourVous(widget.idExp, widget.idDest,
                                                           messageList[index].idMsg);
                                                     },
                                                     child: Text('SUPPRIMER'),
                                                   )
                                                 ],
                                               ));
                                             },
                                             child: Text('Supprimer le message pour vous')),
                                         Text('Signaler le message')
                                       ],
                                     )),
                                     child: Container(
                                       padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                       child: Column(
                                         crossAxisAlignment : CrossAxisAlignment.start,
                                         children: <Widget>[
                                           Text(
                                             messageList[index].msg,
                                             style: Theme.of(context).textTheme.body2,
                                           ),
                                           SizedBox(height: 10.0,),
                                           Text('$date, $heure', style: Theme.of(context).textTheme.caption,)
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         );
                       },
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: Container(
                       height: 60.0,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(20.0),
                           color: Colors.white,
                           border: Border.all(color: Colors.grey, width: 1.0)
                       ),
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
                                 onSubmitted: (value) => sendMsg(),
                                 textCapitalization: TextCapitalization.sentences,
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
                                   color: Colors.redAccent
                               ),
                               child: IconButton(
                                 icon: Icon(Icons.send, color: Colors.white,),
                                 onPressed: () => sendMsg(),
                               )
                           )
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             );
           })
     );
  }
}

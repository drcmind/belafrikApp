import 'package:belafrikapp/models/message.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  String nom, imgUrl, idExp, idDest, idChat;
  Messages({this.nom, this.imgUrl, this.idDest, this.idExp, this.idChat});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    
    final utilisateur = Provider.of<Utilisateur>(context);
    final donnEeUtil = Provider.of<DonnEesUtil>(context);
    TextEditingController messageController = TextEditingController();
    ScrollController scrollController = ScrollController();
    String msgTxt;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(widget.imgUrl),
        ),
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          widget.nom,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<List<Message>>(
        stream: ServiceBDD(idChat: widget.idChat, idExp: widget.idExp,
            idDest: widget.idDest).messages,
        builder: (context, snapshot){

          List<Message> messageList = snapshot.data ?? [];

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messageList.length,
                    itemBuilder: (context, index){

                      final dateDeFirestore = messageList[index].timestamp.toDate();
                      String date = DateFormat.yMMMMd().format(dateDeFirestore);
                      String heure = DateFormat.jm().format(dateDeFirestore);

                    return Container(
                      child: Column(
                        crossAxisAlignment:
                        messageList[index].idExp == utilisateur.idUtil ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: <Widget>[
                          Material(
                            color: messageList[index].idExp == utilisateur.idUtil ? Colors.redAccent : Colors.red[100],
                            borderRadius: messageList[index].idExp == utilisateur.idUtil
                                ? BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft:  Radius.circular(10.0),
                              topRight: Radius.circular(10.0)
                            ) : BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)
                            ),
                            elevation: 6.0,
                            child: messageList[index].idExp == utilisateur.idUtil ? Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                              child: Text(
                                messageList[index].msg,
                              ),
                            ) : Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(widget.imgUrl),
                                  ),
                                  SizedBox(width: 5.0,),
                                  Text(
                                    messageList[index].msg,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          messageList[index].idExp == utilisateur.idUtil
                              ? Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: <Widget>[
                                  Text('$date, $heure'),
                                  SizedBox(width: 5.0,),
                                  Icon(Icons.check, color: Colors.redAccent,)
                                ],
                              ))
                              : Align(alignment: Alignment.centerLeft, child: Text('$date, $heure'))
                        ],
                      ),
                    );
                    },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1.0)
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onSubmitted: (val) => setState(() => msgTxt = val),
                        decoration: InputDecoration(
                          hintText: "Tapez un message",
                          border: InputBorder.none,
                        ),
                        controller: messageController,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white,),
                        onPressed: () async {
                          await ServiceBDD()
                              .envoyezMsg(donnEeUtil.nomUtil, donnEeUtil.photoUrl, donnEeUtil.idUtil,
                              widget.idDest, widget.nom, widget.imgUrl, msgTxt);
                        },
                      )
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

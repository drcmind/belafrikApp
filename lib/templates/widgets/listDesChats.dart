import 'package:belafrikapp/models/chat.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:belafrikapp/templates/widgets/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListesChats extends StatefulWidget {
  @override
  _ListesChatsState createState() => _ListesChatsState();
}

class _ListesChatsState extends State<ListesChats> {
  @override
  Widget build(BuildContext context) {

    final utilisateurs = Provider.of<Utilisateur>(context);
    final listDesChats = Provider.of<List<Chat>>(context) ?? [];

    return ListView.builder(
        itemCount: listDesChats.length,
        itemBuilder: (context, index){

          final dateDeFirestore = listDesChats[index].timestamp.toDate();
          String date = DateFormat.MMMd().format(dateDeFirestore);

          return utilisateurs.idUtil == listDesChats[index].exp['idExp'] ? Container(
            margin: EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(
                    nom :listDesChats[index].dest['nomDest'],
                    imgUrl : listDesChats[index].dest['imgUrlDest'],
                    idExp : listDesChats[index].exp['idExp'],
                    idDest : listDesChats[index].dest['idDest'],
                    idMsg: 'message déjà vu',
                  )));
                },
                onLongPress: () => showDialog(context: context, builder: (context)
                  => SimpleDialog(
                    contentPadding: EdgeInsets.all(8.0),
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          showDialog(context: context, builder: (_)
                          => AlertDialog(
                            contentPadding: EdgeInsets.all(8.0),
                            title: Text('Supprimer la conversation ?'),
                            content: Text('Cette conversation sera '
                                'supprimée de votre boite de reception. '
                                '${listDesChats[index].dest['nomDest']} '
                                'pourra encore la voir'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('ANNULER'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ServiceBDD()
                                      .supprimerConversation(listDesChats[index].exp['idExp'],
                                      listDesChats[index].dest['idDest']);
                                },
                                child: Text('SUPPRIMER'),
                              )
                            ],
                          ));
                        },
                        child: Text('Supprimer la conversation')),
                      Text('Masquer les notification'),
                      Text('Signaler ${listDesChats[index].dest['nomDest']}')
                    ],
                  )),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(listDesChats[index].dest['imgUrlDest']),
                ),
                title: Text(
                  listDesChats[index].dest['nomDest'],
                  maxLines: 1,
                  style: Theme.of(context).textTheme.title,
                ),
                subtitle: Text(
                  listDesChats[index].msg,
                  style: Theme.of(context).textTheme.body1,
                  maxLines: 1,
                ),
                dense: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      date,
                      style: Theme.of(context).textTheme.body1,
                    ),
                    Text(
                      '',
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ],
                )
            ),
          ) : Container(
            margin: EdgeInsets.symmetric(vertical: 02.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListTile(
                onTap: listDesChats[index].nbreMsgNonLis >= 1 ? () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(
                    nom :listDesChats[index].exp['nomExp'],
                    imgUrl : listDesChats[index].exp['imgUrlExp'],
                    idDest : listDesChats[index].exp['idExp'],
                    idExp : listDesChats[index].dest['idDest'],
                    idMsg: listDesChats[index].idMsg,
                  )));
                } : () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(
                    nom :listDesChats[index].exp['nomExp'],
                    imgUrl : listDesChats[index].exp['imgUrlExp'],
                    idDest : listDesChats[index].exp['idExp'],
                    idExp : listDesChats[index].dest['idDest'],
                    idMsg: 'message déjà vu',
                  )));
                },
                onLongPress: () => showDialog(context: context, builder: (context)
                => SimpleDialog(
                  contentPadding: EdgeInsets.all(8.0),
                  children: <Widget>[
                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          showDialog(context: context, builder: (_)
                          => AlertDialog(
                            contentPadding: EdgeInsets.all(8.0),
                            title: Text('Supprimer la conversation ?'),
                            content: Text('Cette conversation sera '
                                'supprimée de votre boite de reception. '
                                '${listDesChats[index].exp['nomExp']} '
                                'pourra encore la voir'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('ANNULER'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ServiceBDD()
                                      .supprimerConversation(listDesChats[index].dest['idDest'],
                                      listDesChats[index].exp['idExp']);
                                },
                                child: Text('SUPPRIMER'),
                              )
                            ],
                          ));
                        },
                        child: Text('Supprimer la conversation')),
                    Text('Masquer les notification'),
                    Text('Signaler ${listDesChats[index].dest['nomDest']}')
                  ],
                )),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(listDesChats[index].exp['imgUrlExp']),
                ),
                title: Text(
                  listDesChats[index].exp['nomExp'],
                  style: Theme.of(context).textTheme.title,
                  maxLines: 1,
                ),
                subtitle: Text(
                  listDesChats[index].msg,
                  style: Theme.of(context).textTheme.body1,
                  maxLines: 1,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    listDesChats[index].nbreMsgNonLis >= 1 ? Column(
                      children: <Widget>[
                        Text(
                          date,
                          style: Theme.of(context).textTheme.body1.copyWith(
                            color: Colors.redAccent
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.redAccent
                          ),
                          child:Text(
                            '${listDesChats[index].nbreMsgNonLis}',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ): Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          date,
                          style: Theme.of(context).textTheme.body1,
                        ),
                        Text(
                          '',
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ],
                    ),
                  ],
                )
            ),
          );
        }
    );
  }
}

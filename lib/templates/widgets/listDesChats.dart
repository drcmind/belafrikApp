import 'package:belafrikapp/models/chat.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:belafrikapp/templates/widgets/inBoxMessages.dart';
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
          bool cMoi = utilisateurs.idUtil == listDesChats[index].exp['idExp'];
          bool contientSlmaTxt = listDesChats[index].msg != '';

          return cMoi ? Container(
            margin: EdgeInsets.only(bottom: 2.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(
                    nom :listDesChats[index].dest['nomDest'],
                    imgUrl : listDesChats[index].dest['imgUrlDest'],
                    idExp : listDesChats[index].exp['idExp'],
                    idDest : listDesChats[index].dest['idDest'],
                    emailDest: listDesChats[index].dest['emailDest'],
                    nbreMsgNonLis: 0,
                  )));
                },
                onLongPress: () => showDialog(context: context, builder: (_)
                => AlertDialog(
                  title: Text('Supp la conversation ?'),
                  content: Text('Cette conversation sera '
                      'supprimée de votre boite de reception. '
                      '${listDesChats[index].dest['nomDest']} '
                      'pourra encore la voir'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => setState(() => Navigator.pop(context)),
                      child: Text('ANNULER'),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() => Navigator.pop(context));
                        ServiceBDD()
                            .supprimerConversation(listDesChats[index].exp['idExp'],
                            listDesChats[index].dest['idDest']);
                      },
                      child: Text('SUPPRIMER'),
                    )
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
                subtitle: contientSlmaTxt ? Text(
                  listDesChats[index].msg,
                  style: Theme.of(context).textTheme.body1,
                  maxLines: 1,
                ) : Text(
                  'Vous aviez envoyé une photo',
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
            margin: EdgeInsets.only(bottom: 2.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListTile(
                onTap: ()  {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(
                    nom :listDesChats[index].exp['nomExp'],
                    emailDest: listDesChats[index].exp['nomExp'],
                    imgUrl : listDesChats[index].exp['imgUrlExp'],
                    idDest : listDesChats[index].exp['idExp'],
                    idExp : listDesChats[index].dest['idDest'],
                    nbreMsgNonLis:listDesChats[index].nbreMsgNonLis,
                  )));
                },
                onLongPress: () => showDialog(context: context, builder: (_)
                => AlertDialog(
                  title: Text('Supp. la conversation ?'),
                  content: Text('Cette conversation sera '
                      'supprimée de votre boite de reception. '
                      '${listDesChats[index].exp['nomExp']} '
                      'pourra encore la voir'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => setState(() => Navigator.pop(context)),
                      child: Text('ANNULER'),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() => Navigator.pop(context));
                        ServiceBDD().supprimerConversation(listDesChats[index].dest['idDest'],
                            listDesChats[index].exp['idExp']);
                        },
                      child: Text('SUPPRIMER'),
                    )
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
                subtitle: contientSlmaTxt ? Text(
                  listDesChats[index].msg,
                  style: Theme.of(context).textTheme.body1,
                  maxLines: 1,
                ) : Text(
                  'Vous aviez reçu une photo',
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

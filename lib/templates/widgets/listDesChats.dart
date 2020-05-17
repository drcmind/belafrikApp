import 'package:belafrikapp/models/chat.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:belafrikapp/templates/widgets/message.dart';
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
    final listDesChats = Provider.of<List<Chat>>(context);

    return ListView.builder(
        itemCount: listDesChats.length,
        itemBuilder: (context, index){

          final dateDeFirestore = listDesChats[index].timestamp.toDate();
          String date = DateFormat.yMMMMd().format(dateDeFirestore);

          return utilisateurs.idUtil == listDesChats[index].exp['idExp'] ? ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(
                  nom :listDesChats[index].dest['nomDest'],
                  imgUrl : listDesChats[index].dest['imgUrlDest'],
                  idExp : listDesChats[index].exp['idExp'],
                  idDest : listDesChats[index].dest['idDest'],
                  idChat : listDesChats[index].idChat,
                )));
              },
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(listDesChats[index].dest['imgUrlDest']),
              ),
              title: Text(
                listDesChats[index].dest['nomDest'],
                style: Theme.of(context).textTheme.title,
              ),
              subtitle: Row(
                children: <Widget>[
                  listDesChats[index].nbreMsgNonLis >= 1 ? Icon(Icons.visibility_off)
                      :Icon(Icons.visibility),
                  SizedBox(width: 5.0),
                  Text(
                    listDesChats[index].msg,
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ],
              ),
              trailing: Text(
                date,
                style: Theme.of(context).textTheme.subtitle,
              )
          ) : utilisateurs.idUtil ==  listDesChats[index].dest['idDest'] ? ListTile(
              onTap: () async {
                await ServiceBDD(idChat: listDesChats[index].idChat).msgLis();
                Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(
                  nom :listDesChats[index].exp['nomExp'],
                  imgUrl : listDesChats[index].exp['imgUrlExp'],
                  idExp : listDesChats[index].exp['idExp'],
                  idDest : listDesChats[index].dest['idDest'],
                  idChat : listDesChats[index].idChat,
                )));
              },
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(listDesChats[index].exp['imgUrlExp']),
              ),
              title: Text(
                listDesChats[index].exp['nomExp'],
                style: Theme.of(context).textTheme.title,
              ),
              subtitle: Text(
                listDesChats[index].msg,
                style: Theme.of(context).textTheme.subtitle,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  listDesChats[index].nbreMsgNonLis >= 1 ? Text(
                    date,
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                        color: Colors.redAccent
                    ),
                  ) : Text(
                    date,
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  listDesChats[index].nbreMsgNonLis >= 1 ? Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent
                    ),
                    child:Text(
                      '${listDesChats[index].nbreMsgNonLis}',
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                          color: Colors.white
                      ),
                    ),
                  ): Container()
                ],
              )
          ) : null;
        }
    );
  }
}

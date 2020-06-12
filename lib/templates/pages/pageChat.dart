import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:belafrikapp/templates/widgets/listDesChats.dart';
import 'package:belafrikapp/templates/widgets/listDesMembres.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageChat extends StatefulWidget {
  @override
  _PageChatState createState() => _PageChatState();
}

class _PageChatState extends State<PageChat> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Discussions',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.black,),
            onPressed: (){},
          )
        ],
      ),
      body: ListesChats(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ListesDesMembres()));
        },
        child: Icon(Icons.add_comment),
      ),
    );
  }
}


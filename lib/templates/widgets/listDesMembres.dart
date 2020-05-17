import 'package:flutter/material.dart';

class ListesDesMembres extends StatefulWidget {
  @override
  _ListesDesMembresState createState() => _ListesDesMembresState();
}

class _ListesDesMembresState extends State<ListesDesMembres> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.redAccent
        ),
        title: Text(
            'Séléctionnez un membre',
          style: TextStyle(color:Colors.white),
        ),
      ),
    )
  }
}

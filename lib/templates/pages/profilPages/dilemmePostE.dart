import 'package:belafrikapp/models/dilemmePoste.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListDilemmePostE extends StatefulWidget {
  @override
  _ListDilemmePostEState createState() => _ListDilemmePostEState();
}

class _ListDilemmePostEState extends State<ListDilemmePostE> {
  @override
  Widget build(BuildContext context) {

    final utilisateur = Provider.of<Utilisateur>(context);
    final dilemme = Provider.of<List<DilemmePostE>>(context) ?? [];

    return ListView.builder(
      itemCount:dilemme.length,
      itemBuilder: (context, index){
        return Container();
      },
    );
  }
}


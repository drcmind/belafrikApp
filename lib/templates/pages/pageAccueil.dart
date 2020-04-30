import 'package:belafrikapp/templates/widgets/listDesUtilisateurs.dart';
import 'package:flutter/material.dart';

class PageAccueil extends StatefulWidget {
  @override
  _PageAccueilState createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              'BELAFRIKA',
              style: Theme.of(context).textTheme.display1.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5
              ),
            ),
            backgroundColor: Colors.white,
            floating: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(height: 100, child:ListUtil()),
                )
              ]
            ),
          )
        ],
      ),
    );
  }
}

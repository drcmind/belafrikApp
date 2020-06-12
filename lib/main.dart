import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/authentification.dart';
import 'package:belafrikapp/templates/accueil.dart';
import 'package:belafrikapp/templates/loginPage1.dart';
import 'package:belafrikapp/templates/widgets/passerrelle.dart';
import 'package:belafrikapp/templates/widgets/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Utilisateur>.value(
      value: ServiceAuth().utilisateur,
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        routes: {
          '/passerelle' : (context) => Passerelle(),
          '/accueil' : (context) => Accueil(),
        },
      ),
    );
  }
}

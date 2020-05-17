import 'package:belafrikapp/models/bellaVotEe.dart';
import 'package:belafrikapp/models/chat.dart';
import 'package:belafrikapp/models/dilemmePost.dart';
import 'package:belafrikapp/models/top10.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:belafrikapp/templates/pages/pageAccueil.dart';
import 'package:belafrikapp/templates/pages/pageAjoutDilemme.dart';
import 'package:belafrikapp/templates/pages/pageChat.dart';
import 'package:belafrikapp/templates/pages/pageCompte.dart';
import 'package:belafrikapp/templates/pages/pageExplore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {

  final PageAccueil _pageAccueil = PageAccueil();
  final PageExplorer _pageExplorer = PageExplorer();
  final PageAjoutDilemme _pageAjoutDilemme = PageAjoutDilemme();
  final PageChat _pageSearch = PageChat();
  final PageCompte _pageCompte = PageCompte();

  int pageIndex = 0;

  Widget _affichePage = PageAccueil();

  Widget _pageSelectionEe(int page){
    switch (page) {
      case 0 :
        return _pageAccueil;
        break;
      case 1 :
        return _pageExplorer;
        break;
      case 2 :
        return _pageAjoutDilemme;
        break;
      case 3 :
        return _pageSearch;
        break;
      case 4 :
        return _pageCompte;
        break;
        default:
          return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    final utilisateur = Provider.of<Utilisateur>(context);

    return StreamProvider<DonnEesUtil>.value(
      value: ServiceBDD(idUtil:utilisateur.idUtil).donnEesUtil,
      child: StreamProvider<List<DonnEesUtil>>.value(
        value: ServiceBDD(idUtil: utilisateur.idUtil).listDesUtils,
        child: StreamProvider<List<Dilemme>>.value(
          value: ServiceBDD(idUtil: utilisateur.idUtil).listDilemme,
          child: StreamProvider<List<Top10>>.value(
            value: ServiceBDD(idUtil: utilisateur.idUtil).top10data,
            child: StreamProvider<List<BellaVotEe>>.value(
              value: ServiceBDD(idUtil: utilisateur.idUtil).bellasVotEes,
              child: StreamProvider<List<Chat>>.value(
                value: ServiceBDD().chats,
                child: Scaffold(
                  body: _affichePage,
                  backgroundColor : Colors.grey[200],
                  bottomNavigationBar: CurvedNavigationBar(
                    backgroundColor : Colors.transparent,
                    height: 50.0,
                    items: <Widget>[
                      Icon(Icons.home, size: 30.0),
                      Icon(Icons.explore, size: 30.0),
                      Icon(Icons.add_circle, size: 30.0, color: Colors.redAccent,),
                      Icon(Icons.sms, size: 30.0),
                      Icon(Icons.person, size: 30.0)
                    ],
                    onTap: (int tappedIndex){
                      setState(() {
                        _affichePage = _pageSelectionEe(tappedIndex);
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

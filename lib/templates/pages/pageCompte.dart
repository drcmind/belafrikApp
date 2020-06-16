import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/authentification.dart';
import 'package:belafrikapp/templates/pages/profilPages/mesPagesProfil/mesBellasVotEes.dart';
import 'package:belafrikapp/templates/pages/profilPages/mesPagesProfil/mesDilemmesPostEs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PageCompte extends StatefulWidget {
  @override
  _PageCompteState createState() => _PageCompteState();
}

class _PageCompteState extends State<PageCompte> {

  int pagesAffichEe = 0;

  @override
  Widget build(BuildContext context) {

    final donnEesUtil = Provider.of<DonnEesUtil>(context);
    final dateDeFirestore = donnEesUtil.dateInscription.toDate();
    String date = DateFormat.yMMMMd().format(dateDeFirestore);

    return donnEesUtil == null ? SafeArea(
        child: Container(
            child: Center(
              child: CircularProgressIndicator(),
            )
        )
    )  : SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            title: Text('Mon Compte', style: TextStyle(color: Colors.black),),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: MediaQuery.of(context).size.height * 0.47,
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: donnEesUtil.lastImgPost == '' ? AssetImage('assets/logo.jpg')
                            :NetworkImage('${donnEesUtil.lastImgPost}'),
                        fit: BoxFit.cover
                      )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(.9),
                            Colors.black12.withOpacity(.1),
                          ],
                          begin: Alignment.bottomRight,
                        )
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.0),
                                image: DecorationImage(
                                  image: donnEesUtil.photoUrl != '' ? NetworkImage('${donnEesUtil.photoUrl}')
                                      :AssetImage('assets/logo.jpg'),
                                  fit: BoxFit.cover
                                )
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(donnEesUtil.nomUtil,
                                style: TextStyle( color: Colors.white, fontSize: 24.0),),
                                Text(donnEesUtil.emailUtil,
                                  style: TextStyle( color: Colors.white, fontSize: 18.0),),
                                Text('${donnEesUtil.nbrePost} post(s) en dilemme',
                                  style: TextStyle( color: Colors.white, fontSize: 16.0),),
                                Text('Membre depuis $date',
                                  style: TextStyle( color: Colors.white, fontSize: 14.0),)
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: (){
                                      ServiceAuth _auth = ServiceAuth();
                                      _auth.signOut();
                                    },
                                    color: Colors.redAccent,
                                    child: Text('Deconnexion', style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                DefaultTabController(
                    length: 2,
                    child: TabBar(
                        labelColor: Colors.red,
                        onTap: (int tappedIndex){
                          setState(() {
                            pagesAffichEe = tappedIndex;
                          });
                        },
                        tabs: <Widget>[
                          Tab(text: 'Dilemme(s) posté(s)'),
                          Tab(text: 'Bella(s) votée(s)')
                        ]
                    )
                )
              ]
            ),
          ),
          pagesAffichEe == 0 ? MesDilemmesPostEs() : MesBellasVotEs()
        ],
      ),
    );
  }
}

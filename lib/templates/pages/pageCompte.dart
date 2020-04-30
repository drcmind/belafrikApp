import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/authentification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PageCompte extends StatefulWidget {
  @override
  _PageCompteState createState() => _PageCompteState();
}

class _PageCompteState extends State<PageCompte> {
  @override
  Widget build(BuildContext context) {

    final donnEesUtil = Provider.of<DonnEesUtil>(context) ?? DonnEesUtil();

    final dateDeFirestore = donnEesUtil.dateInscription.toDate();
    String date = DateFormat.yMMMMd().format(dateDeFirestore);

    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            title: Text('Mon Compte', style: TextStyle(color: Colors.black),),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: 220.0,
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
                            Colors.black12.withOpacity(.05),
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topCenter,
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      onPressed: (){
                        ServiceAuth _auth = ServiceAuth();
                        _auth.signOut();
                      },
                      color: Colors.redAccent,
                      child: Text('Deconnexion', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                )
              ]
            ),
          )
        ],
      ),
    );
  }
}

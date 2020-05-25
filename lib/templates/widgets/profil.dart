import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/authentification.dart';
import 'package:belafrikapp/templates/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilUtilisateur extends StatefulWidget {

  String idUtil, nomUtil, photoUtil, lastImgUrl, emailUtil;
  int nbrePost; Timestamp dateInscription;

  ProfilUtilisateur({this.idUtil, this.nomUtil, this.photoUtil,
    this.lastImgUrl, this.emailUtil, this.nbrePost, this.dateInscription});

  @override
  _ProfilUtilisateurState createState() => _ProfilUtilisateurState();
}

class _ProfilUtilisateurState extends State<ProfilUtilisateur> {
  @override
  Widget build(BuildContext context) {

    final utilisateur = Provider.of<Utilisateur>(context);
    final dateDeFirestore = widget.dateInscription.toDate();
    String date = DateFormat.yMMMMd().format(dateDeFirestore);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: utilisateur.idUtil != widget.idUtil
            ? Text(
          'Profil de ${widget.nomUtil}',
          style: TextStyle(color: Colors.black),
        ):Text(
          'Mon compte',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 265,
            width: double.infinity,
            child: Container(
              decoration:BoxDecoration(
                image: DecorationImage(
                  image: widget.lastImgUrl == '' ? AssetImage('assets/logo.jpg')
                      : NetworkImage('${widget.lastImgUrl}'),
                  fit: BoxFit.cover
                )
              ) ,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(.9),
                      Colors.black.withOpacity(.1),
                    ]
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border : Border.all(color: Colors.white, width: 2.0),
                          image: DecorationImage(
                            image: NetworkImage('${widget.photoUtil}'),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.nomUtil,
                            style: TextStyle(color: Colors.white, fontSize: 24.0),
                          ),
                          Text(
                            widget.emailUtil,
                            maxLines: 1,
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          Text(
                            '${widget.nbrePost} posts en dilemme',
                            maxLines: 1,
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          Text(
                            'Membre depuis $date',
                            maxLines: 1,
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ],
                      ),
                      utilisateur.idUtil == widget.idUtil ? Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: MaterialButton(
                            child: Text('Deconnexion', style: TextStyle(color: Colors.white),),
                            color: Colors.redAccent,
                            onPressed: (){
                              ServiceAuth auth = ServiceAuth();
                              auth.signOut();
                            },
                          ),
                        ),
                      ): Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: <Widget>[
                              MaterialButton(
                                child: Text(
                                  'MESSAGE', style: Theme.of(context)
                                      .textTheme.button.copyWith(
                                  color: Colors.white, letterSpacing: 1.5
                                ),),
                                color: Colors.redAccent,
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(
                                    idExp: utilisateur.idUtil,
                                    idDest: widget.idUtil,
                                    nom: widget.nomUtil,
                                    imgUrl: widget.photoUtil,
                                  )));
                                },
                              ),
                              SizedBox(width: 10.0,),
                              MaterialButton(
                                child: Text(
                                  'VOIR SES DILEMMES', style: Theme.of(context)
                                    .textTheme.button.copyWith(
                                    color: Colors.white, letterSpacing: 1.5
                                ),),
                                color: Colors.blueGrey,
                                onPressed: (){

                                },
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

  }
}

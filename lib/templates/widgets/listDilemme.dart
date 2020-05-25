import 'package:belafrikapp/models/dilemmePost.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/models/vote.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListDilemme extends StatefulWidget {
  @override
  _ListDilemmeState createState() => _ListDilemmeState();
}

class _ListDilemmeState extends State<ListDilemme> {
  @override
  Widget build(BuildContext context) {

    final dilemme = Provider.of<List<Dilemme>>(context) ?? [];
    final donnEeUtil = Provider.of<DonnEesUtil>(context);
    final utilisateur = Provider.of<Utilisateur>(context);
    bool buttonDesactivE = false;

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index){

        final dateDeFirestore = dilemme[index].timestamp.toDate();
        String date = DateFormat.yMMMMd().format(dateDeFirestore);
        String heure = DateFormat.jm().format(dateDeFirestore);
        int totalVote = dilemme[index].totalVote - 1;

        return StreamBuilder<Vote>(
          stream: ServiceBDD(idUtil: utilisateur.idUtil, idPost: dilemme[index].idPost).voteData,
          builder: (context, snapshot) {

            Vote voteData = snapshot.data ?? Vote(idUtilVote: 'Pas id dispo');

            return Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(dilemme[index].utilisateur['imgUtil']),
                        backgroundColor: Colors.grey,
                      ),
                      dense: true,
                      title: Text(
                          dilemme[index].utilisateur['nomUtil'],
                        style: Theme.of(context).textTheme.title,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                          dilemme[index].utilisateur['emailUtil'],
                        style: Theme.of(context).textTheme.subtitle,
                        maxLines: 1,
                      ),
                      trailing: dilemme[index].utilisateur['idUtil'] == utilisateur.idUtil  ? IconButton(
                        onPressed: () async {
                          dynamic statusConnexion = await  Connectivity().checkConnectivity();
                          if(statusConnexion == ConnectivityResult.none){
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Aucune connexion internet'),
                              )
                            );
                          }else{
                            showDialog(context: context, builder: (_){
                              return AlertDialog(
                                title: Text('Suppression de dilemme'),
                                content: Text(
                                  'Voulez-vous supprimer ce dilemme de '
                                      '${dilemme[index].bella1['nomB1']} et '
                                      '${dilemme[index].bella2['nomB2']} ?'
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('NON'),
                                    onPressed: (){
                                      setState(() => Navigator.pop(context));
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('OUI'),
                                    onPressed: buttonDesactivE ? null : () async {
                                      dynamic statusConnexion = await  Connectivity().checkConnectivity();
                                      if(statusConnexion == ConnectivityResult.none){
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Aucune connexion internet'),
                                            )
                                        );
                                      }else{
                                        setState(() =>  buttonDesactivE = true);
                                        Navigator.pop(context);
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Suppression encours...'),
                                            )
                                        );
                                        await ServiceBDD().suppressionDilemme(
                                            dilemme[index].idPost, utilisateur.idUtil, context);
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Suppremé avec succès'),
                                            )
                                        );
                                      }
                                    },
                                  )
                                ],
                              );
                            });
                          }
                        },
                        icon: Icon(Icons.delete, color: Colors.black),
                      ) : IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.more_horiz, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Dilemme posté $date à $heure'
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(dilemme[index].bella1['imgB1']),
                              fit: BoxFit.cover
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(.9),
                                  Colors.black.withOpacity(.1)
                                ],
                                begin: Alignment.bottomRight
                              )
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      dilemme[index].bella1['nomB1'],
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      dilemme[index].bella1['nationalitB1'],
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(dilemme[index].bella2['imgB2']),
                                fit: BoxFit.cover
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(.9),
                                      Colors.black.withOpacity(.1)
                                    ],
                                    begin: Alignment.bottomRight
                                )
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      dilemme[index].bella2['nomB2'],
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      dilemme[index].bella2['nationalitB2'],
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    voteData.idUtilVote == utilisateur.idUtil ? Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            nbreDeVoteB1(dilemme[index].nbreVoteB1, dilemme[index].nbreVoteB2),
                            nbreDeVoteB2(dilemme[index].nbreVoteB1, dilemme[index].nbreVoteB2),
                          ],
                        ),
                        dilemme[index].totalVote == 1 ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            width: 300,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[800]
                            ),
                            child: Text(
                              'Vous etes le 1er à approuver '
                                  'la beauté de ${voteData.nomBvotE} la ${voteData.natBvtE}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ):
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            width: 300,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[800]
                            ),
                            child: Text(
                              'Vous et $totalVote personne(s) ont déjà donnée(s) '
                                  'leur avis sur ce dilemme',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ) : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: buttonDesactivE ? null : () async {
                            dynamic statusConnexion = await Connectivity().checkConnectivity();
                            if(statusConnexion == ConnectivityResult.none){
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Aucune connexion internet'),
                                )
                              );
                            }else{
                              setState(() => buttonDesactivE = true);
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Vote encours pour ${dilemme[index].bella1['nomB1']}'),
                                )
                              );
                              await ServiceBDD(idUtil: utilisateur.idUtil)
                                  .onVoteB1(
                                  dilemme[index].idPost, utilisateur.idUtil,
                                  donnEeUtil.nomUtil, dilemme[index].bella1['idB1'],
                                  dilemme[index].bella1['nomB1'], dilemme[index].bella1['nationalitB1'],
                                  dilemme[index].bella1['imgB1']);

                              Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${dilemme[index].bella1['nomB1']} votée avec succès'),
                                  )
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              height: 30.0,
                              width: 140.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black
                              ),
                              child: Text(
                                'Votez ${dilemme[index].bella1['nomB1']}',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: buttonDesactivE ? null : () async {
                            dynamic statusConnexion = Connectivity().checkConnectivity();
                            if(statusConnexion == ConnectivityResult.none){
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Aucune connexion internet'),
                                  )
                              );
                            }else{
                              setState(() => buttonDesactivE = true);
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Vote encours pour ${dilemme[index].bella2['nomB2']}'),
                                  )
                              );
                              await ServiceBDD(idUtil: utilisateur.idUtil)
                                  .onVoteB2(
                                  dilemme[index].idPost, utilisateur.idUtil,
                                  donnEeUtil.nomUtil, dilemme[index].bella2['idB2'],
                                  dilemme[index].bella2['nomB2'], dilemme[index].bella2['nationalitB2'],
                                  dilemme[index].bella2['imgB2']);
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${dilemme[index].bella2['nomB2']} votée avec succès'),
                                  )
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              height: 30.0,
                              width: 140.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black
                              ),
                              child: Text(
                                'Votez ${dilemme[index].bella2['nomB2']}',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        );
      },
        childCount: dilemme.length,
      ),
    );
  }

  Widget nbreDeVoteB1(nbreB1, nbreB2){
    return nbreB1 >= nbreB2 ? Container(
      height: 30,
      width: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(text: '$nbreB1', style: TextStyle(fontWeight: FontWeight.w900)),
            TextSpan(text: ' Vote(s) ',
            style: TextStyle(fontWeight: FontWeight.w900))
          ]
        ),
      ),
    ): Container(
      height: 30,
      width: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red
      ),
      child: RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(text: '$nbreB1', style: TextStyle(fontWeight: FontWeight.w900)),
              TextSpan(text: ' Vote(s)' ,
                  style: TextStyle(fontWeight: FontWeight.w900))
            ]
        ),
      ),
    );
  }

  Widget nbreDeVoteB2(nbreB1, nbreB2){
    return nbreB2 >= nbreB1 ? Container(
      height: 30,
      width: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.green
      ),
      child: RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(text: '$nbreB2', style: TextStyle(fontWeight: FontWeight.w900)),
              TextSpan(text: ' Vote(s)',
                  style: TextStyle(fontWeight: FontWeight.w900))
            ]
        ),
      ),
    ): Container(
      height: 30,
      width: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red
      ),
      child: RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(text: '$nbreB2', style: TextStyle(fontWeight: FontWeight.w900)),
              TextSpan(text: ' Vote(s)',
                  style: TextStyle(fontWeight: FontWeight.w900))
            ]
        ),
      ),
    );
  }
}

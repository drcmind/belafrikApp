import 'package:belafrikapp/models/commentaire.dart';
import 'package:belafrikapp/models/dilemmePost.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/models/vote.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class MesDilemmesPostEs extends StatefulWidget {
  @override
  _MesDilemmesPostEsState createState() => _MesDilemmesPostEsState();
}

class _MesDilemmesPostEsState extends State<MesDilemmesPostEs> {
  @override
  Widget build(BuildContext context) {

    final dilemme = Provider.of<List<Dilemme>>(context) ?? [];
    final donnEeUtil = Provider.of<DonnEesUtil>(context);
    final utilisateur = Provider.of<Utilisateur>(context);
    bool buttonDesactivE = false;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
              (context, index) {

            final dateDeFirestore = dilemme[index].timestamp.toDate();
            String date = DateFormat.MMMd().format(dateDeFirestore);
            int totalVote = dilemme[index].totalVote - 1;

            return StreamProvider<List<Commentaire>>.value(
              value:ServiceBDD(idPost: dilemme[index].idPost).commentaires,
              child: StreamBuilder<Vote>(
                  stream: ServiceBDD(idUtil: utilisateur.idUtil, idPost: dilemme[index].idPost).voteData,
                  builder: (context, snapshot) {

                    final listCommentaire = Provider.of<List<Commentaire>>(context) ?? [];
                    Vote voteData = snapshot.data ?? Vote(idUtilVote: 'Pas id dispo');
                    TextEditingController messageController = TextEditingController();

                    //Methode pour envoyer un message
                    Future<void> sendCommentaire() async {
                      if (messageController.text.length > 0) {
                        ProgressDialog pr = ProgressDialog(context);
                        pr = ProgressDialog(
                          context,type: ProgressDialogType.Normal,
                          isDismissible: false,
                        );
                        pr.style(
                          message: 'Commentaire encours d\'envoie...',
                          backgroundColor: Colors.white,
                          progressWidget: CircularProgressIndicator(),
                        );
                        await pr.show();
                        await ServiceBDD().ajoutCommentaire(
                            utilisateur.idUtil, donnEeUtil.nomUtil, donnEeUtil.photoUrl,
                            dilemme[index].idPost, messageController.text);
                        await pr.hide();
                        messageController.clear();
                      }
                    }
                    return dilemme[index].utilisateur['idUtil'] == utilisateur.idUtil ? Padding(
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
                              trailing: dilemme[index].utilisateur['idUtil'] == utilisateur.idUtil  ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap:() async {
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
                                                          content: Text('Supprimé avec succès'),
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
                                    child: Container(
                                        height: 20.0,
                                        width: 20.0,
                                        alignment: Alignment.center,
                                        child: Icon(Icons.delete, size: 18.0,)
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    date,
                                    maxLines: 1,
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ],
                              ) : Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                      height: 20,
                                      width: 20,
                                      alignment: Alignment.center,
                                      child:Icon(Icons.more_horiz)
                                  ),
                                  Text(
                                    date,
                                    maxLines: 1,
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    height: 250,
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(dilemme[index].bella1['imgB1']),
                                          fit: BoxFit.cover
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                          ),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(.9),
                                                Colors.black.withOpacity(.1)
                                              ],
                                              begin: Alignment.bottomRight
                                          )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Expanded(
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
                                          voteData.idUtilVote == utilisateur.idUtil
                                              ? nbreDeVoteB1(dilemme[index].nbreVoteB1, dilemme[index].nbreVoteB2)
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 250,
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(dilemme[index].bella2['imgB2']),
                                          fit: BoxFit.cover
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(.9),
                                                Colors.black.withOpacity(.1)
                                              ],
                                              begin: Alignment.bottomRight
                                          )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Expanded(
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
                                          voteData.idUtilVote == utilisateur.idUtil
                                              ? nbreDeVoteB2(dilemme[index].nbreVoteB1, dilemme[index].nbreVoteB2)
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            voteData.idUtilVote == utilisateur.idUtil ? Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      dilemme[index].totalVote == 1 ?Text(
                                          'Vous etes le 1er à approuver '
                                              'la beauté de ${voteData.nomBvotE} la ${voteData.natBvtE}',
                                          style: Theme.of(context).textTheme.body2.copyWith(
                                              color: Colors.black
                                          )
                                      ) : Text(
                                          'Vous et $totalVote personne(s) ont déjà donnée(s) '
                                              'leur avis sur ce dilemme',
                                          style: Theme.of(context).textTheme.body2.copyWith(
                                              color: Colors.black
                                          )
                                      ),
                                      SizedBox(height: 10.0),
                                      listCommentaire.length <=0 ? Container(
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey, width: 1.0)),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 16.0, bottom: 6.0),
                                                  hintText: "Tapez un commentaire",
                                                  border: InputBorder.none,
                                                ),
                                                textCapitalization:
                                                TextCapitalization.sentences,
                                                controller: messageController,
                                              ),
                                            ),
                                            Container(
                                                height: 30.0,
                                                width: 30.0,
                                                margin: EdgeInsets.only(left: 4.0, right: 4.0),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.redAccent),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.send,
                                                    size: 18.0,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () => sendCommentaire(),
                                                )),
                                          ],
                                        ),
                                      ) : ExpansionTile(
                                        title: Text('Afficher le(s) ${listCommentaire.length} '
                                            'commentaire(s) de ce dilemme'),
                                        children: <Widget>[
                                          Container(
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.0),
                                                color: Colors.white,
                                                border: Border.all(color: Colors.grey, width: 1.0)),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(left: 16.0, bottom: 6.0),
                                                      hintText: "Tapez un commentaire",
                                                      border: InputBorder.none,
                                                    ),
                                                    textCapitalization:
                                                    TextCapitalization.sentences,
                                                    controller: messageController,
                                                  ),
                                                ),
                                                Container(
                                                    height: 30.0,
                                                    width: 30.0,
                                                    margin: EdgeInsets.only(left: 4.0, right: 4.0),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.redAccent),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.send,
                                                        size: 18.0,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () => sendCommentaire(),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10.0,),
                                          Container(
                                            height: 200.0,
                                            child: ListView.builder(
                                                itemCount: listCommentaire.length,
                                                itemBuilder: (context, index) => Row(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      backgroundColor: Colors.grey,
                                                      backgroundImage: NetworkImage(listCommentaire[index].imgUrl),
                                                    ),
                                                    SizedBox(width: 10.0,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start ,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              listCommentaire[index].nomUser,
                                                              style: Theme.of(context).textTheme.subhead.copyWith(
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: Icon(Icons.delete, size: 15.0,),
                                                              onPressed: () async {
                                                                ProgressDialog pr = ProgressDialog(context);
                                                                pr = ProgressDialog(
                                                                  context,type: ProgressDialogType.Normal,
                                                                  isDismissible: false,
                                                                );
                                                                pr.style(
                                                                  message: 'Suppression encours...',
                                                                  backgroundColor: Colors.white,
                                                                  progressWidget: CircularProgressIndicator(),
                                                                );
                                                                await pr.show();
                                                                await ServiceBDD(idPost: listCommentaire[index].idPost,
                                                                    idCmtr: listCommentaire[index].idCmtr).supprimerCmtr();
                                                                pr.hide();
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          width:MediaQuery.of(context).size.width * 0.70,
                                                          child: Text(
                                                              listCommentaire[index].msgCmtr
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ) : Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Row(
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
                                            dilemme[index].idPost, donnEeUtil.idUtil,
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
                              ),
                            )
                          ],
                        ),
                      ),
                    ):Container();
                  }
              ),
            );
          },
          childCount: dilemme.length
      ),
    );
  }

  Widget nbreDeVoteB1(nbreB1, nbreB2){
    return nbreB1 >= nbreB2 ? Container(
        height: 23,
        width: 23,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green
        ),
        child: Text(
            '$nbreB1',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ))
    ): Container(
        height: 23,
        width: 23,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red
        ),
        child: Text(
            '$nbreB1',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ))
    );
  }

  Widget nbreDeVoteB2(nbreB1, nbreB2){
    return nbreB2 >= nbreB1 ? Container(
        height: 23,
        width: 23,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green
        ),
        child: Text(
            '$nbreB2',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ))
    ): Container(
        height: 23,
        width: 23,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red
        ),
        child: Text(
            '$nbreB2',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ))
    );
  }
}

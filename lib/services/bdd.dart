import 'package:belafrikapp/models/bellaVotEe.dart';
import 'package:belafrikapp/models/chat.dart';
import 'package:belafrikapp/models/commentaire.dart';
import 'package:belafrikapp/models/dilemmePost.dart';
import 'package:belafrikapp/models/dilemmePoste.dart';
import 'package:belafrikapp/models/message.dart';
import 'package:belafrikapp/models/top10.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/models/vote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class ServiceBDD {
  String idUtil, idPost, idExp, idDest, idMsg, idCmtr;
  ServiceBDD({ this.idUtil, this.idPost, this.idExp,
    this.idDest, this.idMsg, this.idCmtr });

  //collection de reference Utilisateur
  final CollectionReference collectionUtilisateurs = Firestore.instance.collection('utilisateurs');

  //collection de posts
  final CollectionReference collectionPosts = Firestore.instance.collection('posts');

  //collection pour le top10
  final CollectionReference collectionTop10 = Firestore.instance.collection('top10');

  //query de dilemme
  final Query queryDilemme = Firestore.instance.collection('posts')
      .orderBy('timestamp', descending: true);

  //query utilisateurs
  final Query queryUilisateurs = Firestore.instance.collection('utilisateurs')
      .orderBy('nbrePost', descending: true);

  //query Top10
  final Query queryTop10 = Firestore.instance.collection('top10')
      .orderBy('nbreVoteBella', descending: true).limit(10);

  //query toutes les bellas votées
  final Query queryBellaVotEe = Firestore.instance.collection('top10')
      .orderBy('nbreVoteBella', descending: true);

  //collection chat
  final CollectionReference collectionRoom = Firestore.instance.collection('rooms');

  //methode pour enregister un nouveau utilisateur
  Future<void> saveUserData(nomUtil, emailUtil, photoUrl) async {
    try {
      DocumentReference documentReference = collectionUtilisateurs.document(
          idUtil);
      documentReference.snapshots().listen((doc) async {
        if (doc.exists) {
          return null;
        } else {
          return await collectionUtilisateurs.document(idUtil).setData({
            'idUtil': idUtil,
            'nomUtil': nomUtil,
            'emailUtil': emailUtil,
            'photoUrl': photoUrl,
            'nbrePost': 0,
            'lastImgPost': '',
            'dateInscription': FieldValue.serverTimestamp()
          });
        }
      });
    } catch (error) {
      print(error.toString());
    }
  }
  //methode pour fetching les donées utilisateurs
  DonnEesUtil _donnEesUtilFromSnapshot(DocumentSnapshot snapshot) {
    return DonnEesUtil(
      idUtil: snapshot.data['idUtil'],
      nomUtil: snapshot.data['nomUtil'],
      emailUtil: snapshot.data['emailUtil'],
      photoUrl: snapshot.data['photoUrl'],
      nbrePost: snapshot.data['nbrePost'],
      lastImgPost: snapshot.data['lastImgPost'],
      dateInscription: snapshot.data['dateInscription']
    );
  }

  Stream<DonnEesUtil> get donnEesUtil {
    return collectionUtilisateurs.document(idUtil).snapshots()
    .map(_donnEesUtilFromSnapshot);
  }

  //list de tous les utilisateurs from snapshot
  List<DonnEesUtil> _listUtilFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return DonnEesUtil(
          idUtil: doc.data['idUtil'],
          nomUtil: doc.data['nomUtil'],
          emailUtil: doc.data['emailUtil'],
          photoUrl: doc.data['photoUrl'],
          nbrePost: doc.data['nbrePost'],
          lastImgPost: doc.data['lastImgPost'],
          dateInscription: doc.data['dateInscription']
      );
    }).toList();
  }

  //obtention des utilisateurs en stream
  Stream<List<DonnEesUtil>> get listDesUtils {
    return queryUilisateurs.snapshots()
    .map(_listUtilFromSnapshot);
  }

  //methode pour ajouter un dilemme
  Future<void> ajoutPost(context, nomB1, nationalitB1, imgB1, nomB2, nationalitB2, imgB2,
      nomUtil, imgUtil, emailUtil) async {
    try{

      Random radom = Random();
      int idBella1 = radom.nextInt(1000);
      int idBella2 = radom.nextInt(1000);
      String idPost = collectionPosts.document().documentID;

      await collectionUtilisateurs.document(idUtil).updateData({
        'nbrePost' : FieldValue.increment(1),
        'lastImgPost' : imgB1,
      });

      return await collectionPosts.document(idPost).setData({
        'bella1' :{
          'idB1' : idBella1,
          'nomB1': nomB1,
          'nationalitB1' : nationalitB1,
          'imgB1':imgB1
        },
        'bella2' :{
          'idB2' : idBella2,
          'nomB2' : nomB2,
          'nationalitB2': nationalitB2,
          'imgB2' : imgB2
        },
        'utilisateur':{
          'idUtil':idUtil,
          'nomUtil':nomUtil,
          'emailUtil':emailUtil,
          'imgUtil' : imgUtil
        },
        'idPost' :idPost,
        'nbreVoteB1': 0,
        'nbreVoteB2' : 0,
        'totalVotePost' : 0,
        'timestamp': FieldValue.serverTimestamp()
      });
    }catch (error){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Oups! Quelque chose s\'est passé ${error.toString()}'),
        )
      );
    }
  }

  //list des dilemmes from snapshot
  List<Dilemme> _dilemmeListOfSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Dilemme(
        totalVote: doc.data['totalVotePost'] ?? 0,
        nbreVoteB1: doc.data['nbreVoteB1'] ?? 0,
        nbreVoteB2: doc.data['nbreVoteB2']?? 0,
        timestamp: doc.data['timestamp'] ?? '',
        bella1: doc.data['bella1'] ?? {},
        bella2: doc.data['bella2'] ?? {},
        idPost: doc.data['idPost'] ?? '',
        utilisateur: doc.data['utilisateur'] ?? {},
      );
    }).toList();
  }

  //get dilemme en streaming
  Stream<List<Dilemme>> get listDilemme{
    return queryDilemme.snapshots().map(_dilemmeListOfSnapshot);
  }

  Future onVoteB1(idPost, idUser, nomUser, idBella, nomBella, nationalit, imgBella) async {
    try{
      final DocumentReference docummentReference = collectionTop10.document(idBella.toString());
      docummentReference.get().then((ds) async {
        if(ds.exists){
          await collectionPosts.document(idPost).updateData({
            'nbreVoteB1': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
          });
          await collectionPosts.document(idPost).collection('votes')
              .document(idUser).setData({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          return await collectionTop10.document(idBella.toString()).updateData({
            'nbreVoteBella' : FieldValue.increment(1)
          });
        }else{
          await collectionPosts.document(idPost).updateData({
            'nbreVoteB1': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
          });
          await collectionPosts.document(idPost).collection('votes')
              .document(idUser).setData({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          return await collectionTop10.document(idBella.toString()).setData({
            'idBella' : idBella,
            'nomBella': nomBella,
            'nationalitBella' : nationalit,
            'imgBella' : imgBella,
            'nbreVoteBella' : 1,
            'idUser' : idUser
          });
        }
      });
    }catch (error){
      print(error.toString());
    }
  }

  Future onVoteB2(idPost, idUser, nomUser, idBella, nomBella, nationalit, imgBella) async {
    try{
      final DocumentReference docummentReference = collectionTop10.document(idBella.toString());
      docummentReference.get().then((ds) async {
        if(ds.exists){
          await collectionPosts.document(idPost).updateData({
            'nbreVoteB2': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
          });
          await collectionPosts.document(idPost).collection('votes')
              .document(idUser).setData({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          return await collectionTop10.document(idBella.toString()).updateData({
            'nbreVoteBella' : FieldValue.increment(1)
          });
        }else{
          await collectionPosts.document(idPost).updateData({
            'nbreVoteB2': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
          });
          await collectionPosts.document(idPost).collection('votes')
              .document(idUser).setData({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          return await collectionTop10.document(idBella.toString()).setData({
            'idBella' : idBella,
            'nomBella': nomBella,
            'nationalitBella' : nationalit,
            'imgBella' : imgBella,
            'nbreVoteBella' : 1,
            'idUser' : idUser
          });
        }
      });
    }catch (error){
      print(error.toString());
    }
  }

  Vote _voteFromSnapShop(DocumentSnapshot doc){
    return Vote(
        idUtilVote: doc.data['idVoteUtil'] ?? '',
        idPostVote: doc.data['idPost'] ?? '',
        nomBvotE: doc.data['nomBella'] ??'',
        natBvtE: doc.data['nationalite'] ?? '',
        nomUtil: doc.data['nomUtil'] ?? ''
    );
  }

  Stream<Vote> get voteData  {
    return collectionPosts.document(idPost)
        .collection('votes').document(idUtil)
        .snapshots().map(_voteFromSnapShop);
  }

  List<Top10> queryTop10FromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Top10(
          idBella: doc.data['idBella'] ?? 0,
          nomBella: doc.data['nomBella'] ?? '',
          nationalitBella:doc.data['nationalitBella'] ?? '',
          imgBella: doc.data['imgBella'],
          nbreVoteBela: doc.data['nbreVoteBella'],
          idUser: doc.data['idUser'],
      );
    }).toList();
  }

  //strem pour le auery de top10
  Stream<List<Top10>> get top10data{
    return queryTop10.snapshots().map(queryTop10FromSnapshot);
  }

  List<BellaVotEe> queryBellaVotEeFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return BellaVotEe(
        idBella: doc.data['idBella'],
        nomBella: doc.data['nomBella'],
        nationalitBella:doc.data['nationalitBella'],
        imgBella: doc.data['imgBella'],
        nbreVoteBela: doc.data['nbreVoteBella'],
        idUser: doc.data['idUser'],
      );
    }).toList();
  }

  //Stream de toutes les bellas votées
  Stream<List<BellaVotEe>> get bellasVotEes{
    return queryBellaVotEe.snapshots().map(queryBellaVotEeFromSnapshot);
  }

  Future<void> suppressionDilemme(idPost, idUser, context) async {
    try{
      await collectionUtilisateurs.document(idUser).updateData({
        'nbrePost' : FieldValue.increment(-1),
      });
      return await collectionPosts.document(idPost).delete();
    }catch(error){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Oups! quelque chose s\'est mal passé'),
        )
      );
    }
  }

  //créer une nvlle discussion
  Future<void> envoyezMsg (nomExp, emailExp, imgUrlExp, idExp, idDest, nomDest, emailDest,
      imgUrlDest, msgTxt, msgImage){
    try{
      String idMonChat = '$idExp$idDest';
      String idSonChat = '$idDest$idExp';
      String idMessage = collectionRoom.document().documentID;

      DocumentReference docChat = collectionRoom.document(idExp)
          .collection('chats').document(idMonChat);

      docChat.get().then((doc) async {
        if(doc.exists){

          await collectionRoom.document(idExp).collection('chats')
              .document(idMonChat).updateData({
            'nbreMsgNonLis' : FieldValue.increment(1),
            'msgTxt' : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp(),
          });

          await collectionRoom.document(idDest).collection('chats')
              .document(idSonChat).updateData({
            'nbreMsgNonLis' : FieldValue.increment(1),
            'msgTxt' : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp(),
          });

          await collectionRoom.document(idDest)
              .collection('chats').document(idSonChat).collection('messages')
              .document(idMessage).setData({
            'idMsg': idMessage,
            'idExp' : idExp,
            'idDest' : idDest,
            'msgTxt'  : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp()
          });

          return await collectionRoom.document(idExp)
              .collection('chats').document(idMonChat).collection('messages')
              .document(idMessage).setData({
            'idMsg': idMessage,
            'idExp' : idExp,
            'idDest' : idDest,
            'msgTxt'  : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp()
          });

        }else{

          await collectionRoom.document(idDest).collection('chats').document(idSonChat).setData({
            'nbreMsgNonLis' : 1,
            'msgTxt' : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp(),
            'exp' : {
              'idExp' : idExp,
              'nomExp' : nomExp,
              'emailExp' : emailExp,
              'imgUrlExp' : imgUrlExp,
            },
            'dest' : {
              'idDest':idDest,
              'emailDest' : emailDest,
              'nomDest' : nomDest,
              'imgUrlDest' : imgUrlDest
            }
          });

          await collectionRoom.document(idExp).collection('chats').document(idMonChat).setData({
            'nbreMsgNonLis' : 1,
            'msgTxt' : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp(),
            'exp' : {
              'idExp' : idExp,
              'nomExp' : nomExp,
              'emailExp' : emailExp,
              'imgUrlExp' : imgUrlExp,
            },
            'dest' : {
              'idDest':idDest,
              'emailDest' : emailDest,
              'nomDest' : nomDest,
              'imgUrlDest' : imgUrlDest
            }
          });

          await collectionRoom.document(idDest)
              .collection('chats').document(idSonChat).collection('messages')
              .document(idMessage).setData({
            'idMsg': idMessage,
            'idExp' : idExp,
            'idDest' : idDest,
            'msgTxt'  : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp()
          });
          return await collectionRoom.document(idExp)
              .collection('chats').document(idMonChat).collection('messages')
              .document(idMessage).setData({
            'idMsg': idMessage,
            'idExp' : idExp,
            'idDest' : idDest,
            'msgTxt'  : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp()
          });
        }
      });
    }catch (error){
      print(error.toString());
    }
  }

  List<Chat> listChatFromSnapShot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Chat(
          msg : doc.data['msgTxt'],
          msgImage: doc.data['msgImage'],
          nbreMsgNonLis : doc.data['nbreMsgNonLis'],
          timestamp : doc.data['timestamp'],
          exp : doc.data['exp'],
          dest : doc.data['dest'],
       );
    }).toList();
  }

  Stream<List<Chat>> get chats {
    //query chats
    final Query querychat = collectionRoom.document(idExp)
        .collection('chats').orderBy('timestamp', descending: true);
    return querychat.snapshots().map(listChatFromSnapShot);
  }

  //liste des messages issus d'un chat specifique
  List<Message> listMessageFromSnapShot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Message(
        idMsg: doc.data['idMsg'] ?? '',
        idExp: doc.data['idExp'] ?? '',
        idDest: doc.data['idDest'] ?? '',
        msg : doc.data['msgTxt'] ?? '',
        msgImage: doc.data['msgImage'] ?? '',
        timestamp : doc.data['timestamp'] ?? '',
      );
    }).toList();
  }

  Stream<List<Message>> get messages {
    return collectionRoom.document(idExp).collection('chats')
        .document('$idExp$idDest').collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots().map(listMessageFromSnapShot);
  }

  Future<void> msgLis() async {
    try{
      return await collectionRoom.document(idExp).collection('chats')
          .document('$idExp$idDest').updateData({'nbreMsgNonLis' : 0});
    }catch (error){
      print(error.toString());
    }
  }

  Future<void> supprimerConversation(idExp, idDest) async => await collectionRoom
      .document(idExp).collection('chats').document('$idExp$idDest').delete();


  Future<void> sprmerMsgPourVous(idExp, idDest, idMsg) async => await collectionRoom
      .document(idExp).collection('chats').document('$idExp$idDest').collection('messages')
        .document(idMsg).delete();

  Future<void> sprmerMsgPourTous(idExp, idDest, idMsg) async {

    await collectionRoom.document(idDest)
        .collection('chats').document('$idDest$idExp').collection('messages')
        .document(idMsg).updateData({'msg' : 'Message supprimé par l\'éxpediteur'});

    return await collectionRoom.document(idExp)
        .collection('chats').document('$idExp$idDest').collection('messages')
        .document(idMsg).delete();
  }
  
  Stream<QuerySnapshot> get mesMessages => collectionRoom.document(idExp)
        .collection('chats').document('$idExp$idDest').collection('messages')
        .where('idExp', isEqualTo: idExp).snapshots();

  Stream<QuerySnapshot> get nbreMesMsgImg => collectionRoom.document(idExp)
        .collection('chats').document('$idExp$idDest').collection('messages')
        .where('idExp', isEqualTo: idExp).where('msgTxt', isEqualTo:'')
        .snapshots();

  Stream<QuerySnapshot> get nbreSesMsgImg => collectionRoom.document(idExp)
        .collection('chats').document('$idExp$idDest').collection('messages')
        .where('idDest', isEqualTo: idExp).where('msgTxt', isEqualTo:'')
        .snapshots();

  Future<void> blockE() async => await collectionUtilisateurs.document(idDest)
      .collection('bloque').document('$idDest$idExp').setData({'bloque':'bloqué'});

  Future<void> deblockE() async => await collectionUtilisateurs.document(idDest)
      .collection('bloque').document('$idDest$idExp').delete();

  UserBlockE userBlockEFromSnapshot(DocumentSnapshot doc) =>
      UserBlockE(isBlockE: doc.data['bloque'] ?? '');

  Stream<UserBlockE> get blockdata => collectionUtilisateurs
      .document(idDest).collection('bloque').document('$idDest$idExp')
      .snapshots().map(userBlockEFromSnapshot);

  //Ajouter un commentaire
  Future<void> ajoutCommentaire(idUser, nomUser, imgUrl, idPost, msgCmtr) async {
    String idCmtr = collectionPosts.document().documentID;
    return await collectionPosts.document(idPost)
        .collection('commentaires').document(idCmtr).setData({
      'idCmtr' : idCmtr,
      'idUser' : idUser,
      'nomUser' : nomUser,
      'idPost' : idPost,
      'imgUrl' : imgUrl,
      'msgCmtr' : msgCmtr,
      'timestamp' : FieldValue.serverTimestamp()
    });
  }

  List<Commentaire> listCommentaire(QuerySnapshot snapshot)
  => snapshot.documents.map((doc) => Commentaire(
    idCmtr: doc.data[ 'idCmtr'] ?? '',
    idUser: doc.data['idUser'] ?? '',
    nomUser: doc.data['nomUser'] ?? '',
    imgUrl: doc.data['imgUrl'] ?? '',
    idPost: doc.data['idPost'] ?? '',
    msgCmtr: doc.data['msgCmtr'] ?? '',
    timestamp: doc.data['timestamp'] ?? ''
  )).toList();

  Stream<List<Commentaire>> get commentaires => collectionPosts
      .document(idPost).collection('commentaires').snapshots().map(listCommentaire);

  Future<void> supprimerCmtr() async => await collectionPosts
      .document(idPost).collection('commentaires').document(idCmtr).delete();

}

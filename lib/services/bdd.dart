import 'package:belafrikapp/models/bellaVotEe.dart';
import 'package:belafrikapp/models/chat.dart';
import 'package:belafrikapp/models/dilemmePost.dart';
import 'package:belafrikapp/models/message.dart';
import 'package:belafrikapp/models/top10.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/models/vote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:flutter/material.dart';

class ServiceBDD {
  String idUtil, idPost, idChat, idExp, idDest;
  ServiceBDD({ this.idUtil, this.idPost, this.idChat, this.idExp, this.idDest });

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
  final CollectionReference collectionChat = Firestore.instance.collection('chats');

  //query chats
  final Query querychat = Firestore.instance.collection('chats')
      .orderBy('timestamp', descending: true);

  //methode pour enregister un nouveau utilisateur
  Future<void> saveUserData(nomUtil, emailUtil, photoUrl) async {
    try{
      DocumentReference documentReference = collectionUtilisateurs.document(idUtil);
      documentReference.snapshots().listen((doc) async {
        if(doc.exists){
          return null;
        }else{
          return await collectionUtilisateurs.document(idUtil).setData({
            'idUtil' : idUtil,
            'nomUtil' : nomUtil,
            'emailUtil' : emailUtil,
            'photoUrl' : photoUrl,
            'nbrePost' : 0,
            'lastImgPost' : '',
            'dateInscription' : FieldValue.serverTimestamp()
          });
        }
      });
    }catch (error){
      print(error.toString());
    }
  }

  //methode pour fetching les donées utilisateurs
  DonnEesUtil _donnEesUtilFromSnapshot(DocumentSnapshot snapshot) {
    return DonnEesUtil(
      idUtil: snapshot.data['idUtil'] ?? '',
      nomUtil: snapshot.data['nomUtil'] ?? '',
      emailUtil: snapshot.data['emailUtil'] ?? '',
      photoUrl: snapshot.data['photoUrl'] ?? '',
      nbrePost: snapshot.data['nbrePost'] ?? '',
      lastImgPost: snapshot.data['lastImgPost'] ?? '',
      dateInscription: snapshot.data['dateInscription'] ?? ''
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
          idUtil: doc.data['idUtil'] ?? '',
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
          await collectionPosts.document(idPost).collection('votes')
              .document(idUser).setData({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          await collectionPosts.document(idPost).updateData({
            'nbreVoteB1': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
          });
          return await collectionTop10.document(idBella.toString()).updateData({
            'nbreVoteBella' : FieldValue.increment(1)
          });
        }else{
          await collectionPosts.document(idPost).collection('votes')
              .document(idUser).setData({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          await collectionPosts.document(idPost).updateData({
            'nbreVoteB1': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
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
          await collectionPosts.document(idPost).collection('votes')
              .document(idUser).setData({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          await collectionPosts.document(idPost).updateData({
            'nbreVoteB2': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
          });
          return await collectionTop10.document(idBella.toString()).updateData({
            'nbreVoteBella' : FieldValue.increment(1)
          });
        }else{
          await collectionPosts.document(idPost).collection('votes')
              .document(idUser).setData({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          await collectionPosts.document(idPost).updateData({
            'nbreVoteB2': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
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
          idBella: doc.data['idBella'],
          nomBella: doc.data['nomBella'],
          nationalitBella:doc.data['nationalitBella'],
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
  Future<void> envoyezMsg (nomExp, imgUrlExp, idExp, idDest, nomDest, imgUrlDest, msgTxt){
    try{
      String idChat = '$idExp$idDest';
      String idMessage = collectionChat.document().documentID;
      DocumentReference docChat = collectionChat.document(idChat);
      docChat.get().then((doc) async {
        if(doc.exists){
          await collectionChat.document(idChat).setData({
            'nbreMsgNonLis' : FieldValue.increment(1),
            'msg': msgTxt,
            'timestamp' : FieldValue.serverTimestamp(),
          });

          return await collectionChat.document(idChat).collection('messages')
              .document(idMessage).setData({
            'idMsg' : idMessage,
            'idExp' : idExp,
            'idDest' : idDest,
            'nomDest':nomDest,
            'msg' : msgTxt,
            'timestamp' : FieldValue.serverTimestamp(),
            'exp' : {
              'idExp' : idExp,
              'nomExp' : nomExp,
              'imgUrlExp' : imgUrlExp,
            },
            'dest' : {
              'idDest':idDest,
              'nomDest' : nomDest,
              'imgUrlDest' : imgUrlDest
            }
          });
        }else{
          await collectionChat.document(idChat).setData({
            'idChat' : idChat,
            'nbreMsgNonLis' : 1,
            'msg': msgTxt,
            'timestamp' : FieldValue.serverTimestamp(),
            'exp' : {
              'idExp' : idExp,
              'nomExp' : nomExp,
              'imgUrlExp' : imgUrlExp,
            },
            'dest' : {
              'idDest':idDest,
              'nomDest' : nomDest,
              'imgUrlDest' : imgUrlDest
            }
          });
          return await collectionChat.document(idChat).collection('messages')
              .document(idMessage).setData({
            'idMsg' : idMessage,
            'idExp' : idExp,
            'idDest' : idDest,
            'nomDest':nomDest,
            'imgUrlDest' : imgUrlDest,
            'msg' : msgTxt,
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
          idChat: doc.data['idChat'],
          msg : doc.data['msg'],
          nbreMsgNonLis : doc.data['nbreMsgNonLis'],
          timestamp : doc.data['timestamp'],
          exp : doc.data['exp'],
          dest : doc.data['dest'],
      );
    }).toList();
  }

  Stream<List<Chat>> get chats {
    return collectionChat.snapshots().map(listChatFromSnapShot);
  }

  //liste des messages issus d'un chat specifique
  List<Message> listMessageFromSnapShot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Message(
          idMsg: doc.data['idMsg'],
          idExp: doc.data['idExp'],
          nomDest: doc.data['nomDest'],
          msg : doc.data['msg'],
          imgUrlDest: doc.data['imgUrlDest'],
          timestamp : doc.data['timestamp'],
      );
    }).toList();
  }

  Stream<List<Message>> get messages {
    return collectionChat.document(idChat).collection('messages')
        .where('idExp', isEqualTo: idExp).where('idDest', isEqualTo: idDest)
        .snapshots().map(listMessageFromSnapShot);
  }

  Future<void> msgLis() async {
    try{
      return await collectionChat.document(idChat).updateData({
        'nbreMsgNonLis' : 0,
      });
    }catch (error){
      print(error.toString());
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';

class Commentaire {
  String idCmtr, idUser, idPost, nomUser, imgUrl, msgCmtr;
  Timestamp timestamp;
  Commentaire({this.idCmtr, this.idUser, this.idPost, this.nomUser,
    this.msgCmtr, this.timestamp, this.imgUrl});
}
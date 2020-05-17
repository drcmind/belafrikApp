import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String idMsg, idExp, nomDest, imgUrlDest, msg;
  Timestamp timestamp;
  Message({this.idMsg, this.idExp, this.nomDest, this.imgUrlDest,
      this.msg, this.timestamp});
}
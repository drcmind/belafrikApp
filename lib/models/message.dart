import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String idMsg, idExp, idDest, msg, msgImage;
  Timestamp timestamp;
  Message({this.idMsg, this.idExp, this.idDest,
      this.msg, this.timestamp, this.msgImage});
}
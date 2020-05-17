import 'package:cloud_firestore/cloud_firestore.dart';

class Chat{
  String idChat, msg; int nbreMsgNonLis; Timestamp timestamp;
  Map exp, dest;
  Chat({this.idChat, this.msg, this.nbreMsgNonLis, this.timestamp,
  this.dest, this.exp});
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat{
  String msg, msgImage; int nbreMsgNonLis; Timestamp timestamp;
  Map exp, dest;
  Chat({this.msg, this.msgImage, this.nbreMsgNonLis, this.timestamp,
  this.dest, this.exp});
}
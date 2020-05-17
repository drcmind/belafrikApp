import 'package:cloud_firestore/cloud_firestore.dart';

class Dilemme{
  int totalVote, nbreVoteB1, nbreVoteB2;
  Timestamp timestamp;
  String idPost;
  Map bella1, bella2, utilisateur;

  Dilemme({this.totalVote, this.nbreVoteB1, this.nbreVoteB2,
  this.timestamp, this.idPost, this.bella1, this.bella2, this.utilisateur});
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  String idUtil;
  Utilisateur({this.idUtil});
}

class DonnEesUtil {
  String idUtil, nomUtil, photoUrl, emailUtil, lastImgPost;
  int nbrePost; Timestamp dateInscription;

  DonnEesUtil({ this.idUtil, this.nomUtil, this.emailUtil,
  this.nbrePost, this.photoUrl, this.lastImgPost, this.dateInscription});
}
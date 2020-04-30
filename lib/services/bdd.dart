import 'package:belafrikapp/models/utilisateur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceBDD {
  String idUtil;
  ServiceBDD({ this.idUtil });

  //collection de reference Utilisateur
  final CollectionReference collectionUtilisateurs = Firestore.instance.collection('utilisateurs');

  //query utilisateurs
  final Query queryUilisateurs = Firestore.instance.collection('utilisateurs')
      .orderBy('nbrePost', descending: true);

  //methode pour enregister un nouveau utilisateur
  Future<void> saveUserData(nomUtil, emailUtil, photoUrl) async {
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
}


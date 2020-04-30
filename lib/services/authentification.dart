import 'package:belafrikapp/models/utilisateur.dart';
import 'package:belafrikapp/services/bdd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ServiceAuth {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Utilisateur _utilFromFirebaseUser(FirebaseUser utilisateur){
    return utilisateur != null ? Utilisateur(idUtil: utilisateur.uid) : null;
  }

  Stream<Utilisateur> get utilisateur{
    return _auth.onAuthStateChanged.map(_utilFromFirebaseUser);
  }

  //se connecter avec Google
  Future signInWithGoogle() async {
    try{
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final AuthResult authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      
      await ServiceBDD(idUtil: user.uid).saveUserData(user.displayName, user.email, user.photoUrl);

      return _utilFromFirebaseUser(user);

    }catch (error){
      print(error);
    }
  }

  //Deconnexion
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch (error){
      return null;
    }
  }
}
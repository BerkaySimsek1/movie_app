import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/models/sign_up_user.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentuser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<String> signUp(
      {required String email,
      required String password,
      required String username,
      String profilePhoto =
          'https://soccerpointeclaire.com/wp-content/uploads/2021/06/default-profile-pic-e1513291410505.jpg',
      String res = "Some error occured"}) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        AppUser user = AppUser(
            profilePhoto: profilePhoto,
            email: email,
            password: password,
            username: username,
            uid: cred.user!.uid);
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "Success";
        return res;
      }
    } catch (error) {
      res = error.toString();
      return res;
    }
    return res;
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  Future deleteUser() async {
    _auth.currentUser!.delete();
  }
}

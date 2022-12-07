import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String email;
  final String password;
  final String username;
  String profilePhoto;
  final String uid;

  AppUser(
      {required this.email,
      required this.password,
      required this.username,
      required this.uid,
      required this.profilePhoto});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'username': username,
        'uid': uid,
        'profilePhoto': profilePhoto,
      };

  static AppUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return AppUser(
        email: snapshot['email'],
        password: snapshot['password'],
        username: snapshot['username'],
        uid: snapshot['uid'],
        profilePhoto: snapshot['profilePhoto']);
  }
}

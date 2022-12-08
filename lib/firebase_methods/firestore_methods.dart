import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:movie_app/models/comment_models/comments.dart';
import 'package:movie_app/models/comment_models/current_user_comments.dart';
import 'package:movie_app/models/favorites.dart';
import 'package:movie_app/models/watched.dart';
import 'package:movie_app/models/watchlist.dart';

class FirestoreMethods {
  final _firestore = FirebaseFirestore.instance;
  User? user = Auth().currentuser;
  createorUpdateWatclistData(
      Map<String, dynamic> userDataMap, dynamic movieID) async {
    DocumentReference ref = _firestore
        .collection("users")
        .doc(user!.uid)
        .collection("watchlist")
        .doc(movieID);

    return ref.set(userDataMap);
  }

  void validateAndSubmitWatchlist(
      String movieID, bool isAdded, String imagePath, String movieName) async {
    try {
      Watchlist watchList = Watchlist(
          isAdded: isAdded, movieName: movieName, imagePath: imagePath);

      await createorUpdateWatclistData(watchList.getDataMap(), movieID);
    } catch (err) {
      print(err.toString());
    }
  }

  void deleteWatchlist(String movieID) async {
    DocumentReference ref = await _firestore
        .collection("users")
        .doc(user!.uid)
        .collection("watchlist")
        .doc(movieID);
    return ref.delete();
  }

  createorUpdateWatchedData(
      Map<String, dynamic> userDataMap, dynamic movieID) async {
    DocumentReference ref = _firestore
        .collection("users")
        .doc(user!.uid)
        .collection("watched")
        .doc(movieID);

    return ref.set(userDataMap);
  }

  void validateAndSubmitWatched(bool isAdded, String movieID, String imagePath,
      String movieName, double rating) async {
    try {
      Watched watched = Watched(
        isAdded: isAdded,
        movieName: movieName,
        imagePath: imagePath,
        rating: rating,
      );

      await createorUpdateWatchedData(watched.getDataMap(), movieID);
    } catch (err) {
      print(err.toString());
    }
  }

  void deleteWatched(String movieID) async {
    DocumentReference ref = await _firestore
        .collection("users")
        .doc(user!.uid)
        .collection("watched")
        .doc(movieID);
    return ref.delete();
  }

  createorUpdateComments(Map<String, dynamic> userDataMap, dynamic movieID) {
    DocumentReference ref = _firestore
        .collection("comments")
        .doc(movieID)
        .collection("comment")
        .doc(user!.uid);

    return ref.set(userDataMap);
  }

  void validateAndSubmitComments(String comment, String movieID,
      String username, double rating, String uid, String profilePic) async {
    try {
      Comments comments = Comments(
          comment: comment,
          username: username,
          rating: rating,
          uid: uid,
          profilePic: profilePic);

      await createorUpdateComments(comments.getDataMap(), movieID);
    } catch (err) {
      throw Exception(err);
    }
  }

  createorUpdateCurrentUserComments(
      Map<String, dynamic> userDataMap, dynamic movieID) {
    DocumentReference ref = _firestore
        .collection("users")
        .doc(user!.uid)
        .collection("usercomment")
        .doc(movieID);

    return ref.set(userDataMap);
  }

  void validateAndSubmitCurrentUserComments(
    String comment,
    String movieID,
    double rating,
    String movieName,
    String posterPath,
    String uid,
  ) async {
    try {
      CurrentUserComment comments = CurrentUserComment(
        comment: comment,
        rating: rating,
        movieID: int.parse(movieID),
        movieName: movieName,
        posterPath: posterPath,
        uid: uid,
      );

      await createorUpdateCurrentUserComments(comments.getDataMap(), movieID);
    } catch (err) {
      throw Exception(err);
    }
  }

  deleteComment(String movieID) async {
    DocumentReference ref = _firestore
        .collection("users")
        .doc(user!.uid)
        .collection("usercomment")
        .doc(movieID);
    DocumentReference ref2 = _firestore
        .collection("comments")
        .doc(movieID)
        .collection("comment")
        .doc(user!.uid);
    ref.delete();
    ref2.delete();
  }

  updateProfilePhoto(String path) {
    _firestore
        .collection("users")
        .doc(user!.uid)
        .update({'profilePhoto': path});
  }
}

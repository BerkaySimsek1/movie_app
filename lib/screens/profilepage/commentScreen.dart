import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:movie_app/firebase_methods/firestore_methods.dart';
import 'package:movie_app/screens/detailpage/detail.dart';

class ProfileCommentPage extends StatefulWidget {
  const ProfileCommentPage({super.key});

  @override
  State<ProfileCommentPage> createState() => _ProfileCommentPageState();
}

class _ProfileCommentPageState extends State<ProfileCommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Comments"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(Auth().currentuser!.uid)
              .collection("usercomment")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("There is no comment yet."));
              } else {
                return Column(
                  children: snapshot.data!.docs.map(
                    (comment) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(movieId: comment["movieID"]),
                              ));
                        },
                        child: ListTile(
                          leading: Image.network(
                            "$imageBaseUrl${comment["posterPath"]}",
                          ),
                          title: Text("${comment["movieName"]}"),
                          subtitle: Text("${comment["comment"]}"),
                          trailing: IconButton(
                              onPressed: () {
                                FirestoreMethods().deleteComment(
                                    comment["movieID"].toString());
                              },
                              icon: const Icon(Icons.delete)),
                        ),
                      );
                    },
                  ).toList(),
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
            ;
          }),
    );
  }
}

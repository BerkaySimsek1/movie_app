import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:movie_app/screens/detailpage/detail.dart';
import 'package:movie_app/screens/watclistAndWatchedPages/widgets/watchedCard.dart';
import 'package:movie_app/screens/watclistAndWatchedPages/widgets/watchedDialog.dart';

class WatchedPage extends StatefulWidget {
  const WatchedPage({super.key});

  @override
  State<WatchedPage> createState() => _WatchedPageState();
}

class _WatchedPageState extends State<WatchedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Movies You Watched'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(Auth().currentuser!.uid)
                .collection("watched")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Watched page is empty."));
                } else {
                  return GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 4,
                    ),
                    children: snapshot.data!.docs.map((watched) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(movieId: int.parse(watched.id)),
                              ));
                        },
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            height: 320,
                            width: 200,
                            child: Stack(
                              children: [
                                customWatchedCard(
                                  watched: watched,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: customWatchedDialog(
                                    watched: watched,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      ;
                    }).toList(),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

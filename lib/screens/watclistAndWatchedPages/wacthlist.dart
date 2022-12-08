import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:movie_app/screens/detailpage/detail.dart';
import 'package:movie_app/screens/watclistAndWatchedPages/widgets/watchlistAlertDialog.dart';
import 'package:movie_app/screens/watclistAndWatchedPages/widgets/watchlistCard.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchlistState();
}

class _WatchlistState extends State<WatchList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Watchlist'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(Auth().currentuser!.uid)
              .collection("watchlist")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Watchlist is empty"));
              } else {
                return GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 4,
                  ),
                  children: snapshot.data!.docs.map((watchlist) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(movieId: int.parse(watchlist.id)),
                            ));
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          height: 320,
                          width: 200,
                          child: Stack(
                            children: [
                              customWatchlistCard(
                                watchlist: watchlist,
                              ),
                              Positioned(
                                bottom: 25,
                                right: 0,
                                child: customAlertDialog(
                                  watchlist: watchlist,
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
          },
        ));
  }
}

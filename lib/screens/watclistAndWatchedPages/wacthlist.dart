import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:movie_app/firebase_methods/firestore_methods.dart';
import 'package:movie_app/screens/detailpage/detail.dart';

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
                              Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: SizedBox(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 14,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0) +
                                              const EdgeInsets.only(top: 7),
                                          child: SizedBox(
                                            width: 200,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                "$imageBaseUrl${watchlist["imagePath"]}",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(flex: 1),
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(watchlist["movieName"]),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 25,
                                right: 0,
                                child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(actions: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Lottie.asset(
                                                  'assets/delete.json'),
                                            ),
                                            const Align(
                                              alignment: Alignment.center,
                                              child: Text('Are you sure?'),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      FirestoreMethods()
                                                          .deleteWatchlist(
                                                              watchlist.id);
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Yes')),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('No')),
                                              ],
                                            )
                                          ]);
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                        Icons.delete_outline_rounded)),
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

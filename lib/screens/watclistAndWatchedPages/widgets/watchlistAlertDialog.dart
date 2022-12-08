import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/firebase_methods/firestore_methods.dart';

class customAlertDialog extends StatelessWidget {
  customAlertDialog({Key? key, required this.watchlist}) : super(key: key);
  QueryDocumentSnapshot<Map<String, dynamic>> watchlist;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  backgroundColor: Colors.black45,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  actions: [
                    Align(
                      alignment: Alignment.center,
                      child: Lottie.asset('assets/delete.json'),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text('Are you sure?'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              FirestoreMethods().deleteWatchlist(watchlist.id);

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
        icon: const Icon(Icons.delete_outline_rounded));
  }
}

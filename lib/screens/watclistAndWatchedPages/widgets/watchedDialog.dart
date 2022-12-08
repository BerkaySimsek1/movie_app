import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/firebase_methods/firestore_methods.dart';

class customWatchedDialog extends StatelessWidget {
  customWatchedDialog({Key? key, required this.watched}) : super(key: key);
  QueryDocumentSnapshot<Map<String, dynamic>> watched;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
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
                              FirestoreMethods().deleteWatched(watched.id);
                              FirestoreMethods().deleteComment(watched.id);

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

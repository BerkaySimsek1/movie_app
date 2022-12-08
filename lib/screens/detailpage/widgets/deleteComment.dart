import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/firebase_methods/firestore_methods.dart';
import 'package:movie_app/models/movie_data_models/movie_detail.dart';

class deleteComment extends StatelessWidget {
  deleteComment({Key? key, required this.value}) : super(key: key);
  MovieDetails value;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
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
                            FirestoreMethods()
                                .deleteComment(value.id.toString());
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
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.delete));
  }
}

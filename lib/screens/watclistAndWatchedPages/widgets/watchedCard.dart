import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/consts/api.dart';

class customWatchedCard extends StatelessWidget {
  customWatchedCard({Key? key, required this.watched}) : super(key: key);
  QueryDocumentSnapshot<Map<String, dynamic>> watched;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: SizedBox(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0) +
                    const EdgeInsets.only(top: 7),
                child: SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      "$imageBaseUrl${watched["imagePath"]}",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0) +
                      const EdgeInsets.only(top: 8),
                  child: Text(watched["movieName"]),
                )),
            Text("Your rating: ${watched["rating"]}")
          ],
        ),
      ),
    );
  }
}

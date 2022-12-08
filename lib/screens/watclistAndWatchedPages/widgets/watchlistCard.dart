import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/consts/api.dart';

class customWatchlistCard extends StatelessWidget {
  customWatchlistCard({Key? key, required this.watchlist}) : super(key: key);
  QueryDocumentSnapshot<Map<String, dynamic>> watchlist;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        child: Column(
          children: [
            Expanded(
              flex: 14,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0) +
                    const EdgeInsets.only(top: 7),
                child: SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(watchlist["movieName"]),
                )),
          ],
        ),
      ),
    );
  }
}

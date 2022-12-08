import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movie_app/consts/genres.dart';
import 'package:movie_app/models/movie_data_models/movie_detail.dart';

class getGenres extends StatelessWidget {
  const getGenres({
    Key? key,
    required this.value,
  }) : super(key: key);

  final MovieDetails value;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var e in value.genres!)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10) +
                  const EdgeInsets.only(left: 10),
              child: Container(
                height: 40,
                width: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                ),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "${Genres().listOfGenres[e.id]} ",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_data_models/movie_detail.dart';

class yearAndRating extends StatelessWidget {
  const yearAndRating({
    Key? key,
    required this.value,
  }) : super(key: key);

  final MovieDetails value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8),
          child: Text(
            "${value.releaseDate!.year}",
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        (value.voteAverage) == null
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: Row(
                  children: [
                    const Text(
                      'IMDb rating: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 250, 239, 43),
                    ),
                    Text(
                      value.voteAverage!.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

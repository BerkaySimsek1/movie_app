import 'package:flutter/material.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/models/movie_data_models/movie_detail.dart';

class posterAndTitle extends StatelessWidget {
  const posterAndTitle({
    Key? key,
    required this.sizeWidth,
    required this.value,
  }) : super(key: key);

  final double sizeWidth;
  final MovieDetails value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: sizeWidth,
          child: (value.backdropPath == null)
              ? Image.network(
                  defaultMovieImage,
                  height: 300,
                )
              : Image.network(
                  "$imageBaseUrl${value.backdropPath}",
                  fit: BoxFit.fill,
                ),
        ),
        Positioned(
          bottom: 2,
          child: Container(
            color: Colors.black38,
            constraints: BoxConstraints(maxWidth: sizeWidth),
            child: Text(
              value.title!,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

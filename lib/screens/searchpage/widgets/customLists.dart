import 'package:flutter/material.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/models/movie_data_models/movies.dart';
import 'package:movie_app/models/movie_data_models/search_movie.dart';
import 'package:movie_app/screens/detailpage/detail.dart';

class SearchList extends StatelessWidget {
  SearchList(
      {Key? key,
      required this.cont,
      required this.sizeWidth,
      required this.sizeHeight,
      required this.snapshot})
      : super(key: key);

  final ScrollController cont;
  final double sizeWidth;
  final double sizeHeight;
  AsyncSnapshot<List<SearchResult>> snapshot;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: cont,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final value = snapshot.data![index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(movieId: value.id!),
                ));
          },
          child: SizedBox(
              width: sizeWidth,
              height: sizeHeight / 5,
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: Row(
                  children: [
                    (value.posterPath == null)
                        ? Image.network(defaultMovieImage)
                        : Image.network(
                            "$imageBaseUrl${value.posterPath}",
                            fit: BoxFit.fill,
                          ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                    ),
                    SizedBox(width: sizeWidth / 2, child: Text(value.title!)),
                  ],
                ),
              )),
        );
      },
    );
  }
}

class defaultMovieList extends StatelessWidget {
  defaultMovieList(
      {Key? key,
      required this.sizeWidth,
      required this.sizeHeight,
      required this.snapshot})
      : super(key: key);

  final double sizeWidth;
  final double sizeHeight;
  AsyncSnapshot<List<Movies>> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final value = snapshot.data![index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(movieId: value.id!),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: SizedBox(
                    width: sizeWidth,
                    height: sizeHeight / 5,
                    child: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Row(
                        children: [
                          (value.posterPath == null)
                              ? Image.network(defaultMovieImage)
                              : Image.network(
                                  "$imageBaseUrl${value.posterPath}",
                                  fit: BoxFit.fill,
                                ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 10,
                          ),
                          SizedBox(
                              width: sizeWidth / 2, child: Text(value.title!))
                        ],
                      ),
                    )),
              ),
            ),
          );
        });
  }
}

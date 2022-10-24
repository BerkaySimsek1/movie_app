import 'package:flutter/material.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/models/movies.dart';
import 'package:movie_app/models/searchMovie.dart';
import 'package:movie_app/screens/detail.dart';
import 'package:movie_app/service/api2.dart';

class SearchMovie extends StatefulWidget {
  const SearchMovie({super.key});

  @override
  State<SearchMovie> createState() => _SearchMovieState();
}

class _SearchMovieState extends State<SearchMovie> {
  ScrollController _controller = ScrollController();
  String query = "";
  int page = 1;
  int totalPage = 4;
  Future<void> fetchData() async {
    MovieDatas().searchMovies(query, page);
    page++;
  }

  // infinite page yapmayı dene
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeWidth = size.width;
    var sizeHeight = size.height;
    return Scaffold(
        appBar: AppBar(
          title: TextField(
              onChanged: (value) {
                query = value;
              },
              decoration: InputDecoration(hintText: "Search a movie")),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.search)),
          ],
        ),
        body: FutureBuilder<List<SearchResult>>(
            future: MovieDatas().searchMovies(query, 1),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final value = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(movieId: value.id!),
                            ));
                      },
                      child: SizedBox(
                          width: sizeWidth,
                          height: sizeHeight / 5,
                          child: Card(
                            child: Row(
                              children: [
                                (value.posterPath == null)
                                    ? Image.network(defaultMovieImage)
                                    : Image.network(
                                        "$imageBaseUrl${value.posterPath}",
                                        fit: BoxFit.fill,
                                      ),
                                SizedBox(
                                    width: sizeWidth / 2,
                                    child: Text(value.title!))
                              ],
                            ),
                          )),
                    );
                  },
                );
              } else {
                return FutureBuilder<List<Movies>>(
                  future: MovieDatas().getPopularMovies(page),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final value = snapshot.data![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailPage(movieId: value.id!),
                                    ));
                              },
                              child: SizedBox(
                                  width: sizeWidth,
                                  height: sizeHeight / 5,
                                  child: Card(
                                    child: Row(
                                      children: [
                                        (value.posterPath == null)
                                            ? Image.network(defaultMovieImage)
                                            : Image.network(
                                                "$imageBaseUrl${value.posterPath}",
                                                fit: BoxFit.fill,
                                              ),
                                        SizedBox(
                                            width: sizeWidth / 2,
                                            child: Text(value.title!))
                                      ],
                                    ),
                                  )),
                            );
                          });
                    } else {
                      return const Text("");
                    }
                  },
                );
              }
            }));
  }
}

import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_data_models/movies.dart';
import 'package:movie_app/models/movie_data_models/search_movie.dart';
import 'package:movie_app/screens/searchpage/widgets/customLists.dart';
import 'package:movie_app/service/dioMethods.dart';

class SearchMovie extends StatefulWidget {
  const SearchMovie({super.key});

  @override
  State<SearchMovie> createState() => _SearchMovieState();
}

class _SearchMovieState extends State<SearchMovie> {
  String query = "";
  int page = 1;
  int totalPage = 1;
  bool searchBar = true;
  bool isEmpty = false;
  ScrollController cont = ScrollController();

  Future<void> getTotalPage() async {
    var result = await MovieDatas().movieSearchLastPage(query);
    setState(() {
      totalPage = result.totalPages!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeWidth = size.width;
    var sizeHeight = size.height;

    return Scaffold(
        appBar: AppBar(
          title: TextField(
              onSubmitted: (value) {
                if (value.isEmpty) {
                  setState(() {
                    searchBar = true;
                  });
                } else {
                  searchBar = false;
                  page = 1;
                }
              },
              onChanged: (value) {
                setState(() {
                  query = value;
                  if (query == "") {
                    searchBar = true;
                  } else {
                    searchBar = false;
                    page = 1;
                    getTotalPage();
                  }
                });
              },
              decoration: const InputDecoration(hintText: "Search a movie")),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.search),
            ),
          ],
        ),
        body: Column(
          children: [
            searchBar
                ? Expanded(
                    child: FutureBuilder<List<Movies>>(
                      future: MovieDatas().getTopRatedMovies(1),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return defaultMovieList(
                            sizeWidth: sizeWidth,
                            sizeHeight: sizeHeight,
                            snapshot: snapshot,
                          );
                        } else {
                          return const Text("");
                        }
                      },
                    ),
                  )
                : Expanded(
                    child: FutureBuilder<List<SearchResult>>(
                        future: MovieDatas().searchMovies(query, page),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text(
                                      "This movie does not exist. Please search again."));
                            } else {
                              return Column(
                                children: [
                                  Expanded(
                                    child: SearchList(
                                      cont: cont,
                                      sizeWidth: sizeWidth,
                                      sizeHeight: sizeHeight,
                                      snapshot: snapshot,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 45,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              if (page > 1) {
                                                setState(() {
                                                  page--;
                                                });
                                              }
                                              cont.animateTo(
                                                  cont.position.minScrollExtent,
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.fastOutSlowIn);
                                            },
                                            child: const Text("Previous Page")),
                                        Text("$page/$totalPage"),
                                        ElevatedButton(
                                            onPressed: () {
                                              if (page < totalPage) {
                                                setState(() {
                                                  page++;
                                                });
                                              }
                                              cont.animateTo(
                                                  cont.position.minScrollExtent,
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.fastOutSlowIn);
                                            },
                                            child: const Text("Next Page")),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                          } else {
                            return const Center(
                              child: Text("Loading"),
                            );
                          }
                        }),
                  ),
          ],
        ));
  }
}

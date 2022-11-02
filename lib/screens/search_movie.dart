import 'package:flutter/material.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/models/movie_data_models/movies.dart';
import 'package:movie_app/models/movie_data_models/search_movie.dart';
import 'package:movie_app/screens/detail.dart';
import 'package:movie_app/service/api2.dart';

class SearchMovie extends StatefulWidget {
  const SearchMovie({super.key});

  @override
  State<SearchMovie> createState() => _SearchMovieState();
}

class _SearchMovieState extends State<SearchMovie> {
  String query = "";
  int page = 1;
  //totalpage i almak için bir yol bul.
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

  // infinite page yapmayı dene ve arama sonucu çıkmazsa sonuç çıkamdı farklı bir şekilde deneyin diye not bırak
  // veya controller koyup top'a gelmeye çalış
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
                  getTotalPage();
                }
              },
              onChanged: (value) {
                query = value;
              },
              decoration: const InputDecoration(hintText: "Search a movie")),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    searchBar = false;
                    page = 1;
                    getTotalPage();
                    if (query == '') {
                      searchBar = true;
                    }
                  });
                },
                icon: const Icon(Icons.search)),
          ],
        ),
        body: Column(
          children: [
            searchBar
                ? Expanded(
                    child: FutureBuilder<List<Movies>>(
                      future: MovieDatas().getPopularMovies(page),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
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
                                                ? Image.network(
                                                    defaultMovieImage)
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
                                    child: ListView.builder(
                                      controller: cont,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final value = snapshot.data![index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPage(
                                                          movieId: value.id!),
                                                ));
                                          },
                                          child: SizedBox(
                                              width: sizeWidth,
                                              height: sizeHeight / 5,
                                              child: Card(
                                                child: Row(
                                                  children: [
                                                    (value.posterPath == null)
                                                        ? Image.network(
                                                            defaultMovieImage)
                                                        : Image.network(
                                                            "$imageBaseUrl${value.posterPath}",
                                                            fit: BoxFit.fill,
                                                          ),
                                                    SizedBox(
                                                        width: sizeWidth / 2,
                                                        child:
                                                            Text(value.title!))
                                                  ],
                                                ),
                                              )),
                                        );
                                      },
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

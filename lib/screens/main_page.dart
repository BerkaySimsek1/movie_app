import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie_next_page.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/models/movies.dart';
import 'package:movie_app/screens/detail.dart';
import 'package:movie_app/screens/see_all.dart';
import 'package:movie_app/service/api2.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int randomMovieId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deneme();
  }

  void deneme() async {
    int randomPage = Random().nextInt(500);
    int randomIndex = Random().nextInt(20);
    List<Movies> list = await MovieDatas().getRandomMovie(randomPage);
    randomMovieId = list[randomIndex].id!;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeWidth = size.width;
    var sizeHeight = size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sinefy",
          style: TextStyle(color: Colors.cyanAccent, fontSize: 32),
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  deneme();
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(movieId: randomMovieId)));
              },
              child: Text("Get a movie"))
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Popular Movies",
                      style: Theme.of(context).textTheme.headline5,
                    )),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeeAll(
                            whichList: "Popular",
                          ),
                        ));
                  },
                  child: const Text("See all")),
            ],
          ),
          Expanded(
            flex: 2,
            child: FutureBuilder<List<Movies>>(
              future: MovieDatas().getPopularMovies(1),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final value = snapshot.data![index];
                        return customCard(value: value);
                      });
                } else {
                  return const Text("");
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Most Watched",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeeAll(whichList: ""),
                        ));
                  },
                  child: const Text("See all"))
            ],
          ),
          Expanded(
            flex: 2,
            child: FutureBuilder<List<Movies>>(
              future: MovieDatas().getTopRatedMovies(1),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final value = snapshot.data![index];
                        return customCard(value: value);
                      });
                } else {
                  return const Text("");
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Hi"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Hi"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Hi"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Hi"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Hi")
      ]),
    );
  }
}

class customCard extends StatelessWidget {
  const customCard({
    Key? key,
    required this.value,
  }) : super(key: key);

  final Movies value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                movieId: value.id!,
              ),
            ));
      },
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 330,
          width: 200,
          child: Card(
            child: SizedBox(
              child: Column(
                children: [
                  Expanded(
                    flex: 16,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0) +
                          const EdgeInsets.only(top: 7),
                      child: SizedBox(
                        width: 200,
                        child: Image.network(
                          "$imageBaseUrl${value.posterPath}",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                        ),
                        child: Text(value.title!),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

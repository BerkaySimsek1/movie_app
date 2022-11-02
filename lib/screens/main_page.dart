import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/models/movie_data_models/movies.dart';
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
  late int randompage;
  late int randomIndex;
  @override
  void initState() {
    super.initState();
    randomPage();
  }

  Future<void> randomPage() async {
    randompage = Random().nextInt(500);
    randomIndex = Random().nextInt(20);
    setState(() {});

    List<Movies> list = await MovieDatas().getPopularMovies(randompage);

    randomMovieId = list[randomIndex].id!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sinefy",
          style: TextStyle(color: Colors.cyanAccent, fontSize: 32),
        ),
        actions: [
          TextButton(
              onPressed: () {
                randomPage();
                Timer(const Duration(milliseconds: 100), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(movieId: randomMovieId)));
                });
              },
              child: const Text("Get a movie"))
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
                          builder: (context) => const SeeAll(
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
                        return CustomCard(value: value);
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
                          builder: (context) => const SeeAll(whichList: ""),
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
                        return CustomCard(value: value);
                      });
                } else {
                  return const Text("");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
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

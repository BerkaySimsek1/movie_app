import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/consts/colors.dart';
import 'package:movie_app/consts/numbers.dart';
import 'package:movie_app/models/movie_data_models/movies.dart';
import 'package:movie_app/screens/detailpage/detail.dart';
import 'package:movie_app/screens/mainpage/widgets/custom_card.dart';
import 'package:movie_app/screens/seeAllScreens/see_all.dart';
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
    randomIndex = Random().nextInt(19);
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
          style: TextStyle(color: logoColor, fontSize: textSize2),
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
              child: const Text(
                "Get a movie",
                style: TextStyle(color: textbuttonColor, fontSize: textSize1),
              ))
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
                  child: const Text(
                    "See all",
                    style:
                        TextStyle(color: textbuttonColor, fontSize: textSize1),
                  )),
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
                child: const Text(
                  "See all",
                  style: TextStyle(color: textbuttonColor, fontSize: textSize1),
                ),
              )
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

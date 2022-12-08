import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:movie_app/consts/colors.dart';
import 'package:movie_app/consts/numbers.dart';
import 'package:movie_app/models/movie_data_models/movies.dart';
import 'package:movie_app/screens/detailpage/detail.dart';
import 'package:movie_app/screens/mainpage/widgets/customTitle.dart';
import 'package:movie_app/screens/mainpage/widgets/custom_card.dart';
import 'package:movie_app/service/dioMethods.dart';

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
          customTitles(title: 'Popular Movies', whichList: 'Popular'),
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
          customTitles(title: 'Popular Movies', whichList: ''),
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

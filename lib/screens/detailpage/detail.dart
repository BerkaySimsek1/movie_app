import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/consts/colors.dart';
import 'package:movie_app/consts/genres.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:movie_app/firebase_methods/firestore_methods.dart';
import 'package:movie_app/models/movie_data_models/credits.dart';
import 'package:movie_app/models/movie_data_models/movie_detail.dart';
import 'package:movie_app/models/movie_data_models/recommendations.dart';
import 'package:movie_app/screens/detailpage/widgets/cards.dart';
import 'package:movie_app/service/api2.dart';

import '../../consts/numbers.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.movieId});

  final int movieId;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  late bool isAddedWatchlist = false;
  bool isMovieWatched = false;
  double rate = 1;
  TextEditingController commentMovietf = TextEditingController();
  String username = "";
  late final AnimationController _addedController;
  late final AnimationController _removedController;
  late Timer _timer;

  Future<void> getUsername() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Auth().currentuser!.uid)
        .get()
        .then((value) => username = value.data()!["username"]);
    Future.delayed(const Duration(microseconds: 1));
    setState(() {});
  }

  void isWatchlistAdded() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(Auth().currentuser!.uid)
        .collection("watchlist")
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          int i = 0;
          int k = 0;
          value.docs.forEach((element) {
            if (element.id == widget.movieId.toString()) {
              k = i;
              isAddedWatchlist = value.docs[k].data()["isAdded"];
            }
            i++;
          });
        } else {}
      },
    );
  }

  void isMovieInWatched() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(Auth().currentuser!.uid)
        .collection("watched")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        int i = 0;
        int k = 0;
        value.docs.forEach((element) {
          if (element.id == widget.movieId.toString()) {
            k = i;
            isMovieWatched = value.docs[k].data()["isAdded"];
          }
          i++;
        });
      } else {}
    });
  }

  @override
  void initState() {
    getUsername();
    super.initState();
    isWatchlistAdded();
    isMovieInWatched();
    _addedController = AnimationController(vsync: this);
    _removedController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _addedController.dispose();
    _removedController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeWidth = size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<MovieDetails>(
              future: MovieDatas().getMovieDetails(widget.movieId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final value = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
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
                      ),
                      customButtons(sizeWidth, context, value),

                      Row(
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
                                  padding:
                                      const EdgeInsets.only(top: 8.0, left: 8),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'IMDb rating: ',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      const Icon(
                                        Icons.star,
                                        color:
                                            Color.fromARGB(255, 250, 239, 43),
                                      ),
                                      Text(
                                        value.voteAverage!.toStringAsFixed(1),
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, top: 10),
                        child: Text(
                          'Overview',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 8),
                          child: Text(value.overview!),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var e in value.genres!)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10) +
                                        const EdgeInsets.only(left: 10),
                                child: Container(
                                  height: 40,
                                  width: 85,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)],
                                  ),
                                  child: Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "${Genres().listOfGenres[e.id]} ",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      // bu kısımları da container ile sarmalayabilirsin belki
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Recommendation Movies",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: FutureBuilder<List<Recommendations>>(
                          future: MovieDatas().getRecommendation(value.id!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "Coming Soon",
                                    style: TextStyle(fontSize: 40),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final value = snapshot.data![index];
                                      return CustomRecommendationCard(
                                        movieId: value.id!,
                                        value: value,
                                      );
                                    });
                              }
                            } else {
                              return const Center(child: Text(""));
                            }
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Cast",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: FutureBuilder<List<Cast>>(
                          future: MovieDatas().getCharacters(value.id!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final value = snapshot.data![index];
                                    return CustomCastCard(value: value);
                                  });
                            } else {
                              return const Text("");
                            }
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 8),
                        child: Text(
                          "Comments: ",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          "(To make a comment you have to add this movie to watched.)",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),

                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("comments")
                            .doc(value.id.toString())
                            .collection("comment")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 12.0),
                                child: SizedBox(
                                  height: 250,
                                  child: Center(
                                      child: Text("There is no comment yet.")),
                                ),
                              );
                            } else {
                              return Column(
                                children: snapshot.data!.docs.map(
                                  (comment) {
                                    if (comment['comment'] == '') {
                                      return const SizedBox();
                                    } else {
                                      return ListTile(
                                        title: Text("${comment["username"]}"),
                                        subtitle: Text("${comment["comment"]}"),
                                        trailing: SizedBox(
                                          width: 100,
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Color.fromARGB(
                                                    255, 250, 239, 43),
                                              ),
                                              Text(
                                                  comment["rating"].toString()),
                                              (comment["uid"] ==
                                                      Auth().currentuser!.uid)
                                                  ? IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              actions: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Lottie
                                                                      .asset(
                                                                          'assets/delete.json'),
                                                                ),
                                                                const Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                      'Are you sure?'),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          FirestoreMethods().deleteComment(value
                                                                              .id
                                                                              .toString());
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: const Text(
                                                                            'Yes')),
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: const Text(
                                                                            'No')),
                                                                  ],
                                                                )
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete))
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ).toList(),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),

                      const SizedBox(
                        height: 100,
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                      "Some error occured. Please try again later.");
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }

  Row customButtons(
      double sizeWidth, BuildContext context, MovieDetails value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
            width: sizeWidth / 2.1,
            child: isAddedWatchlist
                ? ElevatedButton(
                    onPressed: () {
                      customLottie(context, 'assets/minus.json',
                              'Successfully removed!')
                          .then((value) {
                        if (_timer.isActive) {
                          _timer.cancel();
                        }
                      });

                      setState(() {
                        FirestoreMethods()
                            .deleteWatchlist(value.id!.toString());
                        isAddedWatchlist = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: negativeButtonColor,
                    ),
                    child: const Text("Remove from watchlist"))
                : ElevatedButton(
                    onPressed: () {
                      customLottie(context, 'assets/successful.json',
                              "Successfully added!")
                          .then((value) {
                        if (_timer.isActive) {
                          _timer.cancel();
                        }
                      });
                      setState(() {
                        FirestoreMethods().validateAndSubmitWatchlist(
                            value.id!.toString(),
                            true,
                            value.posterPath!,
                            value.title!);
                        isWatchlistAdded();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: positiveButtonColor),
                    child: const Text("Watchlist"))),
        SizedBox(
            width: sizeWidth / 2.1,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: positiveButtonColor),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Color.fromARGB(255, 34, 29, 29),
                        title: const Text("Rate this movie"),
                        actions: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RatingBar.builder(
                              initialRating: 1,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                rate = rating;
                              },
                            ),
                          ),
                          TextField(
                            controller: commentMovietf,
                            decoration: InputDecoration(
                                hintText: isMovieWatched
                                    ? "Update your comment"
                                    : "Comment here."),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isMovieWatched
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: negativeButtonColor),
                                      onPressed: () {
                                        setState(() {
                                          FirestoreMethods().deleteWatched(
                                              value.id!.toString());
                                          FirestoreMethods().deleteComment(
                                              value.id.toString());
                                          isMovieWatched = false;
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text("Remove"))
                                  : const Text(""),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff276660)),
                                  onPressed: () {
                                    FirestoreMethods().validateAndSubmitWatched(
                                        true,
                                        value.id.toString(),
                                        value.posterPath!,
                                        value.title!,
                                        rate);

                                    FirestoreMethods()
                                        .validateAndSubmitComments(
                                            commentMovietf.text,
                                            value.id.toString(),
                                            username,
                                            rate,
                                            Auth().currentuser!.uid);

                                    FirestoreMethods()
                                        .validateAndSubmitCurrentUserComments(
                                      commentMovietf.text,
                                      value.id.toString(),
                                      rate,
                                      value.title!,
                                      value.posterPath!,
                                      Auth().currentuser!.uid,
                                    );

                                    isMovieInWatched();
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: isMovieWatched
                                      ? const Text("Update")
                                      : const Text("Add watched.")),
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                child: isMovieWatched
                    ? const Text("Update or Remove")
                    : const Text("Watched"))),
      ],
    );
  }

  Future<dynamic> customLottie(
      BuildContext context, String asset, String text) {
    return showDialog(
      context: context,
      builder: (context) {
        _timer = Timer(Duration(milliseconds: 2500), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100.0),
              child: Column(
                children: [
                  Center(
                    child: Lottie.asset(asset, width: 200, height: 200),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Bobbers',
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(text),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

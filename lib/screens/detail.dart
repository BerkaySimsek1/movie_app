import 'package:flutter/material.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/consts/genres.dart';
import 'package:movie_app/models/movie_data_models/credits.dart';
import 'package:movie_app/models/movie_data_models/movie_detail.dart';
import 'package:movie_app/models/movie_data_models/recommendations.dart';
import 'package:movie_app/service/api2.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.movieId});

  final int movieId;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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
                  return const Center(
                    child: Text(
                      "Loading...",
                      style: TextStyle(fontSize: 26),
                    ),
                  );
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

                      // firebase kurduğun zaman watclist ve watched diye 2 farklı liste tanımla eğer istenen film watchlistteyse veya
                      // izlendiyse çıkar diye bir buton oluştur.
                      // bu işlemleri provider ile yap(doğru anladıysan)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                              width: sizeWidth / 2.1,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Add watchlist"))),
                          SizedBox(
                              width: sizeWidth / 2.1,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Watched"))),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8),
                        child: Text(
                          "${value.releaseDate!.year}-${value.releaseDate!.month}-${value.releaseDate!.day}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(3.0) +
                            const EdgeInsets.only(top: 7),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 5,
                                      blurStyle: BlurStyle.normal,
                                      color: Colors.white30,
                                      spreadRadius: 2)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 8),
                              child: Text(value.overview!),
                            )),
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
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.amber,
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
                      Text(
                        "Recommendation Movies",
                        style: Theme.of(context).textTheme.headline5,
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

                      Text(
                        "Cast",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 300,
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
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const SnackBar(
                      content: Text("Some error occured. Please try again."));
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
}

class GetGenres extends StatelessWidget {
  const GetGenres({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final List widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var e in widget)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10) +
                const EdgeInsets.only(left: 10),
            child: Container(
              height: 40,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.amber,
              ),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "${Genres().listOfGenres[e]} ",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
      ],
    );
  }
}

// bazılarının biyografisi yok onları hallet
class CustomCastCard extends StatefulWidget {
  const CustomCastCard({
    Key? key,
    required this.value,
  }) : super(key: key);

  final Cast value;

  @override
  State<CustomCastCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCastCard> {
  @override
  Widget build(BuildContext context) {
    // circleavatar yerine container'a dön
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            width: 90,
            child: (widget.value.profilePath == null)
                ? Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.network(
                          defaultCastImage,
                          fit: BoxFit.fill,
                        )))
                : Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.network(
                        "$imageBaseUrl${widget.value.profilePath}",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 5.0,
            ),
            child: SizedBox(
              width: 140,
              child: Column(
                children: [
                  Text(
                    widget.value.originalName!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.value.character!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomRecommendationCard extends StatelessWidget {
  const CustomRecommendationCard(
      {Key? key, required this.movieId, required this.value})
      : super(key: key);
  final int movieId;
  final Recommendations value;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(movieId: movieId),
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
                        child: (value.posterPath == null)
                            ? Image.network(defaultMovieImage)
                            : Image.network(
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

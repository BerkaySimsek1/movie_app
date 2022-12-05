// bazılarının biyografisi yok onları hallet
import 'package:flutter/material.dart';
import 'package:movie_app/screens/detailpage/detail.dart';

import '../../../consts/api.dart';
import '../../../consts/numbers.dart';
import '../../../models/movie_data_models/credits.dart';
import '../../../models/movie_data_models/recommendations.dart';

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
            width: 80,
            child: (widget.value.profilePath == null)
                ? Container(
                    height: 70,
                    width: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          defaultCastImage,
                          fit: BoxFit.fill,
                        )))
                : Container(
                    height: 70,
                    width: 80,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
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
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    softWrap: true,
                    style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(255, 146, 72, 72)),
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
              builder: (context) => DetailPage(
                movieId: value.id!,
              ),
            ));
      },
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: height1,
          width: width1,
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: SizedBox(
              child: Column(
                children: [
                  Expanded(
                    flex: 16,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0) +
                          const EdgeInsets.only(top: 7),
                      child: Container(
                        width: width1,
                        decoration: BoxDecoration(boxShadow: const [
                          BoxShadow(
                            blurRadius: 1.25,
                            blurStyle: BlurStyle.outer,
                            color: Colors.grey,
                            offset: Offset(1, 1),
                          )
                        ], borderRadius: BorderRadius.circular(13)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: (value.backdropPath == null)
                              ? Image.network(
                                  defaultMovieImage,
                                  height: 300,
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  "$imageBaseUrl${value.posterPath}",
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: padding2,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            value.title!,
                            style: TextStyle(fontSize: textSize1),
                          ),
                        ),
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

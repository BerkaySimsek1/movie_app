import 'package:flutter/material.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/consts/numbers.dart';
import 'package:movie_app/models/movie_data_models/movies.dart';
import 'package:movie_app/screens/detailpage/detail.dart';

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
                            blurRadius: 2.5,
                            blurStyle: BlurStyle.outer,
                            color: Colors.grey,
                            offset: Offset(1, 1),
                          )
                        ], borderRadius: BorderRadius.circular(13)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.network(
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

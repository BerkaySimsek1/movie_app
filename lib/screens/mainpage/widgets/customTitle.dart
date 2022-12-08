import 'package:flutter/material.dart';
import 'package:movie_app/consts/colors.dart';
import 'package:movie_app/consts/numbers.dart';
import 'package:movie_app/screens/seeAllScreens/see_all.dart';

class customTitles extends StatelessWidget {
  customTitles({Key? key, required this.title, required this.whichList})
      : super(key: key);
  String title, whichList;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline5,
              )),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeeAll(
                      whichList: whichList,
                    ),
                  ));
            },
            child: const Text(
              "See all",
              style: TextStyle(color: textbuttonColor, fontSize: textSize1),
            )),
      ],
    );
  }
}

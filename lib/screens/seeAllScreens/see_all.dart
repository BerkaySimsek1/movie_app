import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie_next_page.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/models/movie_data_models/movies.dart';
import 'package:movie_app/screens/detailpage/detail.dart';
import 'package:movie_app/service/api2.dart';

class SeeAll extends StatefulWidget {
  const SeeAll({super.key, required this.whichList});
  final String whichList;
  @override
  State<SeeAll> createState() => _SeeAllState();
}

// provider ile sayfa atlamayı yap
class _SeeAllState extends State<SeeAll> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<pageControllerCubit>(context).resetPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<pageControllerCubit, int>(
          builder: (context, page) {
            return Text("Page: $page");
          },
        ),
        actions: [
          Row(
            children: [
              BlocBuilder<pageControllerCubit, int>(
                builder: (context, page) {
                  return IconButton(
                      onPressed: () {
                        if (page > 1) {
                          BlocProvider.of<pageControllerCubit>(context)
                              .previousPage();
                          controller.animateTo(0,
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
                      },
                      icon: const Icon(Icons.arrow_back));
                },
              ),
              IconButton(
                  onPressed: () {
                    BlocProvider.of<pageControllerCubit>(context).nextPage();
                    controller.animateTo(0,
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                  icon: const Icon(Icons.arrow_forward)),
            ],
          )
        ],
      ),
      body: BlocBuilder<pageControllerCubit, int>(
        builder: (context, page) {
          return FutureBuilder<List<Movies>>(
            future: widget.whichList == "Popular"
                ? MovieDatas().getPopularMovies(page)
                : MovieDatas().getTopRatedMovies(page),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  controller: controller,
                  itemCount: snapshot.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    final value = snapshot.data![index];
                    return CustomGridCard(value: value);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      ),
    );
  }
}

class CustomGridCard extends StatelessWidget {
  const CustomGridCard({
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
              builder: (context) => DetailPage(movieId: value.id!),
            ));
      },
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 320,
          width: 200,
          child: Card(
            child: SizedBox(
              child: Column(
                children: [
                  Expanded(
                    flex: 14,
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
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(value.title!),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

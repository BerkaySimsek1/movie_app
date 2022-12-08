import 'package:dio/dio.dart';
import 'package:movie_app/consts/api.dart';
import 'package:movie_app/models/movie_data_models/credits.dart';
import 'package:movie_app/models/movie_data_models/movie_detail.dart';
import 'package:movie_app/models/movie_data_models/movies.dart';
import 'package:movie_app/models/movie_data_models/recommendations.dart';
import 'package:movie_app/models/movie_data_models/search_movie.dart';

class MovieDatas {
  Dio dio = Dio();

  Future<List<Movies>> getPopularMovies(int page) async {
    try {
      final response = await dio.get(
        "$movieBaseUrl/movie/popular?api_key=$apiKey&page=$page",
      );
      final List data = response.data["results"];
      return data.map((e) => Movies.fromJson(e)).toList();
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<List<Movies>> getTopRatedMovies(int page) async {
    try {
      final response = await dio.get(
        "$movieBaseUrl/movie/top_rated?api_key=$apiKey&page=$page",
      );
      final List data = response.data["results"];
      return data.map((e) => Movies.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<MovieDetails> getMovieDetails(int movieid) async {
    try {
      final response =
          await dio.get("$movieBaseUrl/movie/$movieid?api_key=$apiKey");
      return MovieDetails.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Recommendations>> getRecommendation(int id) async {
    try {
      final response = await dio.get(
        "$movieBaseUrl/movie/$id/recommendations?api_key=$apiKey",
      );

      final List data = response.data["results"];
      return data.map((e) => Recommendations.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Cast>> getCharacters(int id) async {
    try {
      final response = await dio.get(
        "$movieBaseUrl/movie/$id/credits?api_key=$apiKey",
      );

      final List data = response.data["cast"];
      return data.map((e) => Cast.fromJson(e)).toList();
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<List<Movies>> getRandomMovie(int page) async {
    try {
      final response = await dio
          .get("$movieBaseUrl/movie/popular?api_key=$apiKey&page=$page");
      final List data = response.data["results"];
      return data.map((e) => Movies.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<SearchResult>> searchMovies(String query, int page) async {
    try {
      final response = await dio.get(
          "$movieBaseUrl/search/movie?api_key=$apiKey&query=$query&page=$page");
      final List data = response.data["results"];
      return data.map((e) => SearchResult.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Search> movieSearchLastPage(
    String query,
  ) async {
    try {
      final response = await dio
          .get("$movieBaseUrl/search/movie?api_key=$apiKey&query=$query");

      return Search.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }
}

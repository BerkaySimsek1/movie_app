// ignore_for_file: public_member_api_docs, sort_constructors_first
class CurrentUserComment {
  dynamic comment;

  dynamic rating;
  dynamic movieName;
  dynamic posterPath;
  dynamic movieID;
  dynamic uid;
  CurrentUserComment({
    required this.comment,
    required this.rating,
    required this.movieName,
    required this.posterPath,
    required this.movieID,
    required this.uid,
  });
  dynamic getDataMap() {
    return {
      "comment": comment,
      "rating": rating,
      "movieName": movieName,
      "posterPath": posterPath,
      "movieID": movieID,
      "uid": uid,
    };
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Watched {
  final dynamic isAdded;
  final dynamic movieName;
  final dynamic imagePath;
  final dynamic rating;
  Watched({
    required this.isAdded,
    required this.movieName,
    required this.imagePath,
    required this.rating,
  });

  dynamic getDataMap() {
    return {
      "isAdded": isAdded,
      "movieName": movieName,
      "imagePath": imagePath,
      "rating": rating,
    };
  }
}

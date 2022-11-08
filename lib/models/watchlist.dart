// ignore_for_file: public_member_api_docs, sort_constructors_first
class Watchlist {
  final dynamic isAdded;
  final dynamic movieName;
  final dynamic imagePath;
  Watchlist({
    required this.isAdded,
    required this.movieName,
    required this.imagePath,
  });

  dynamic getDataMap() {
    return {
      "isAdded": isAdded,
      "movieName": movieName,
      "imagePath": imagePath,
    };
  }
}

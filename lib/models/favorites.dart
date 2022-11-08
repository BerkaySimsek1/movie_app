class Favorites {
  
  final dynamic movieName;
  final dynamic imagePath;
  final dynamic isFavorite;
  Favorites({
    required this.isFavorite,
    required this.movieName,
    required this.imagePath,
  });

  dynamic getDataMap() {
    return {
      "isFavorite": isFavorite,
      "movieName": movieName,
      "imagePath": imagePath,
    };
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Comments {
  dynamic comment;
  dynamic username;
  dynamic rating;
  Comments({
    required this.comment,
    required this.username,
    required this.rating,
  });
  dynamic getDataMap() {
    return {
      "comment": comment,
      "username": username,
      "rating": rating,
    };
  }
}

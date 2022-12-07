// ignore_for_file: public_member_api_docs, sort_constructors_first
class Comments {
  dynamic comment;
  dynamic username;
  dynamic rating;
  dynamic uid;
  dynamic profilePic;
  Comments({
    required this.comment,
    required this.username,
    required this.rating,
    required this.uid,
    required this.profilePic,
  });
  dynamic getDataMap() {
    return {
      "comment": comment,
      "username": username,
      "rating": rating,
      "uid": uid,
      "profilePic": profilePic
    };
  }
}

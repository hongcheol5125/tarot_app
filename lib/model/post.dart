
class Post {
  String? title;
  String? content;
  List<dynamic> images = [];
  int views = 0;
  DateTime date;

  Post({this.title, this.content, this.images = const [], this.views = 0, required this.date});
}
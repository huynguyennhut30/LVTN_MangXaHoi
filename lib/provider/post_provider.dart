
import 'package:flutter/widgets.dart';
import 'package:lvtn_mangxahoi/models/post.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];
  int _selectedPostIndex = 0;

  List<Post> get posts => _posts;
  int get selectedPostIndex => _selectedPostIndex;

  void setPosts(List<Post> posts) {
    _posts = posts;
    notifyListeners();
  }

  void setSelectedPostIndex(int index) {
    _selectedPostIndex = index;
    notifyListeners();
  }
}
final feedProvider = PostsProvider();
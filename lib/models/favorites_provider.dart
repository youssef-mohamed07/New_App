import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Map> _favorites = [];

  List<Map> get favorites => _favorites;

  void toggleFavorite(Map article) {
    if (_favorites.any((a) => a['url'] == article['url'])) {
      _favorites.removeWhere((a) => a['url'] == article['url']);
    } else {
      _favorites.add(article);
    }
    notifyListeners();
  }

  bool isFavorited(Map article) {
    return _favorites.any((a) => a['url'] == article['url']);
  }
}


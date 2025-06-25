import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_session_ids';

  // Singleton pattern
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  /// Get list of favorite session IDs
  Future<List<String>> getFavoriteSessionIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  /// Save list of favorite session IDs
  Future<void> saveFavoriteSessionIds(List<String> sessionIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, sessionIds);
  }

  /// Add a session ID to favorites
  Future<void> addFavorite(String sessionId) async {
    final favorites = await getFavoriteSessionIds();
    if (!favorites.contains(sessionId)) {
      favorites.add(sessionId);
      await saveFavoriteSessionIds(favorites);
    }
  }

  /// Remove a session ID from favorites
  Future<void> removeFavorite(String sessionId) async {
    final favorites = await getFavoriteSessionIds();
    favorites.remove(sessionId);
    await saveFavoriteSessionIds(favorites);
  }

  /// Check if a session is favorited
  Future<bool> isFavorite(String sessionId) async {
    final favorites = await getFavoriteSessionIds();
    return favorites.contains(sessionId);
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    await saveFavoriteSessionIds([]);
  }
}

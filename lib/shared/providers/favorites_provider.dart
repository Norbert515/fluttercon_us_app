import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/favorites_service.dart';
import '../models/models.dart';
import 'data_providers.dart';

// StateNotifier for managing favorites
class FavoritesNotifier extends StateNotifier<List<String>> {
  final FavoritesService _favoritesService;

  FavoritesNotifier(this._favoritesService) : super([]) {
    _loadFavorites();
  }

  // Load favorites from storage
  Future<void> _loadFavorites() async {
    final favorites = await _favoritesService.getFavoriteSessionIds();
    state = favorites;
  }

  // Toggle favorite status of a session
  Future<void> toggleFavorite(String sessionId) async {
    if (state.contains(sessionId)) {
      await _favoritesService.removeFavorite(sessionId);
      state = state.where((id) => id != sessionId).toList();
    } else {
      await _favoritesService.addFavorite(sessionId);
      state = [...state, sessionId];
    }
  }

  // Check if a session is favorited
  bool isFavorite(String sessionId) {
    return state.contains(sessionId);
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    await _favoritesService.clearAllFavorites();
    state = [];
  }

  // Reload favorites from storage
  Future<void> reload() async {
    await _loadFavorites();
  }
}

// Provider for favorites notifier
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  return FavoritesNotifier(FavoritesService());
});

// Provider to check if a specific session is favorited
final isFavoriteProvider = Provider.family<bool, String>((ref, sessionId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.contains(sessionId);
});

// Provider to get favorite sessions
final favoriteSessionsProvider = FutureProvider<List<Session>>((ref) async {
  final favoriteIds = ref.watch(favoritesProvider);
  final allSessions = await ref.watch(allSessionsProvider.future);

  return allSessions.where((session) => favoriteIds.contains(session.id)).toList();
});

// Provider to get non-service favorite sessions
final nonServiceFavoriteSessionsProvider = FutureProvider<List<Session>>((ref) async {
  final favoriteSessions = await ref.watch(favoriteSessionsProvider.future);
  return favoriteSessions.where((session) => !session.isServiceSession).toList();
});

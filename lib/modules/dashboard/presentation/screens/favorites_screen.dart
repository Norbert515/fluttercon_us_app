import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/shared.dart';
import '../widgets/session_card.dart';
import '../../../details/presentation/screens/session_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  void _navigateToSessionDetail(BuildContext context, Session session) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SessionDetailScreen(session: session)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteSessionsAsync = ref.watch(nonServiceFavoriteSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          // Clear all favorites button
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'clear_all') {
                final shouldClear = await _showClearAllDialog(context);
                if (shouldClear == true) {
                  await ref.read(favoritesProvider.notifier).clearAllFavorites();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('🗑️ All favorites cleared'), behavior: SnackBarBehavior.floating),
                    );
                  }
                }
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem<String>(
                    value: 'clear_all',
                    child: Row(children: [Icon(Icons.clear_all), SizedBox(width: 8), Text('Clear All Favorites')]),
                  ),
                ],
          ),
        ],
      ),
      body: favoriteSessionsAsync.when(
        data: (favoriteSessions) {
          if (favoriteSessions.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(nonServiceFavoriteSessionsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteSessions.length,
              itemBuilder: (context, index) {
                final session = favoriteSessions[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: index < favoriteSessions.length - 1 ? 16 : 0),
                  child: SessionCard(session: session, onTap: () => _navigateToSessionDetail(context, session)),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Error loading favorites: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(nonServiceFavoriteSessionsProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.pink.withValues(alpha: 0.1),
                    Colors.purple.withValues(alpha: 0.1),
                    Colors.blue.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Text(
              'No Favorites Yet',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Text(
              'Start exploring sessions and tap the ❤️ button to add them to your favorites!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.explore),
              label: const Text('Explore Sessions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showClearAllDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear All Favorites?'),
            content: const Text(
              'This will remove all sessions from your favorites list. This action cannot be undone.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Clear All'),
              ),
            ],
          ),
    );
  }
}

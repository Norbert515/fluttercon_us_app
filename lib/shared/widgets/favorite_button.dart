import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';

class FavoriteButton extends ConsumerStatefulWidget {
  final String sessionId;
  final String sessionTitle;
  final double size;
  final Color? favoriteColor;
  final Color? unfavoriteColor;

  const FavoriteButton({
    super.key,
    required this.sessionId,
    required this.sessionTitle,
    this.size = 24.0,
    this.favoriteColor,
    this.unfavoriteColor,
  });

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() async {
    // Start animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Toggle favorite
    await ref.read(favoritesProvider.notifier).toggleFavorite(widget.sessionId);

    // Show snackbar
    if (mounted) {
      final isFavorite = ref.read(isFavoriteProvider(widget.sessionId));
      final message =
          isFavorite
              ? '❤️ Added "${widget.sessionTitle}" to favorites!'
              : '💔 Removed "${widget.sessionTitle}" from favorites';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(isFavoriteProvider(widget.sessionId));
    final favoriteColor = widget.favoriteColor ?? Colors.red;
    final unfavoriteColor = widget.unfavoriteColor ?? Colors.grey[400]!;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: InkWell(
              onTap: _onTap,
              borderRadius: BorderRadius.circular(widget.size),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(isFavorite),
                    size: widget.size,
                    color: isFavorite ? favoriteColor : unfavoriteColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

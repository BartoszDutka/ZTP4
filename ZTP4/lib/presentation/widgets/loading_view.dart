import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Widget wyświetlający stan ładowania
class LoadingView extends StatefulWidget {
  final String message;

  const LoadingView({
    super.key,
    this.message = 'Ładowanie...',
  });

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.elevatedShadow,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(
            widget.message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

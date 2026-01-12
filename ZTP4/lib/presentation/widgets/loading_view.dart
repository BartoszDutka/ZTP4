import 'package:flutter/material.dart';

/// Widget wyświetlający stan ładowania
class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({
    super.key,
    this.message = 'Ładowanie...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

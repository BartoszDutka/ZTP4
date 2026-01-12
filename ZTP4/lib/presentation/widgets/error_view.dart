import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Widget wyświetlający błąd z możliwością ponowienia akcji
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryButtonText;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryButtonText = 'Spróbuj ponownie',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppTheme.errorColor,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Ups! Coś poszło nie tak',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.errorColor.withOpacity(0.1),
                ),
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: Text(retryButtonText),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

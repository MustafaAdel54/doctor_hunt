import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../../../generated/style_atoms.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox,
    this.onRetry,
    this.retryText,
  });

  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryText;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: palette.surfaceAlt),
            Gaps.h16,
            Text(
              message,
              style: context.medium.copyWith(color: palette.textSub),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              Gaps.h24,
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText ?? 'Retry'),
                style: TextButton.styleFrom(foregroundColor: palette.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

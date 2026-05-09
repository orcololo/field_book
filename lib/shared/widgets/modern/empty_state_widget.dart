import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/theme/folium_theme.dart';

/// Modern empty state widget with organic design
class EmptyStateWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FoliumTheme.space48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with breathing animation
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: (widget.iconColor ?? colorScheme.primary).withValues(
                    alpha: 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 64,
                  color: (widget.iconColor ?? colorScheme.primary).withValues(
                    alpha: 0.4,
                  ),
                ),
              ),
            ),

            const SizedBox(height: FoliumTheme.space32),

            // Title
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: FoliumTheme.space12),

            // Message
            Text(
              widget.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // Action button
            if (widget.actionLabel != null && widget.onAction != null) ...[
              const SizedBox(height: FoliumTheme.space32),
              ElevatedButton.icon(
                onPressed: widget.onAction,
                icon: const Icon(Icons.add),
                label: Text(widget.actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FoliumTheme.space24,
                    vertical: FoliumTheme.space16,
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

/// Predefined empty states
class EmptyStates {
  EmptyStates._();

  static Widget noPlants({
    required BuildContext context,
    VoidCallback? onAddPlant,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return EmptyStateWidget(
      icon: Icons.eco,
      title: l10n.noPlants,
      message: l10n.startCollectionMsg,
      actionLabel: l10n.addPlant,
      onAction: onAddPlant,
    );
  }

  static Widget noSessions({
    required BuildContext context,
    VoidCallback? onCreateSession,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return EmptyStateWidget(
      icon: Icons.explore,
      title: l10n.noCollectionSessions,
      message: l10n.createSessionMsg,
      actionLabel: l10n.newSession,
      onAction: onCreateSession,
      iconColor: Theme.of(context).colorScheme.tertiary,
    );
  }

  static Widget noResults({required BuildContext context, String? query}) {
    final l10n = AppLocalizations.of(context)!;

    return EmptyStateWidget(
      icon: Icons.search_off,
      title: l10n.noResultsFound,
      message: query != null
          ? l10n.noResultsForQuery(query)
          : l10n.adjustFilters,
      iconColor: FoliumTheme.warning,
    );
  }

  static Widget noPhotos({required BuildContext context}) {
    final l10n = AppLocalizations.of(context)!;

    return EmptyStateWidget(
      icon: Icons.photo_library_outlined,
      title: l10n.noPhotos,
      message: l10n.addPhotosMsg,
    );
  }

  static Widget noMeasurements({required BuildContext context}) {
    final l10n = AppLocalizations.of(context)!;

    return EmptyStateWidget(
      icon: Icons.straighten,
      title: l10n.noMeasurementsTitle,
      message: l10n.recordMeasurementsMsg,
    );
  }

  static Widget error({
    required BuildContext context,
    required String message,
    VoidCallback? onRetry,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return EmptyStateWidget(
      icon: Icons.error_outline,
      title: l10n.somethingWentWrong,
      message: message,
      actionLabel: onRetry != null ? l10n.tryAgain : null,
      onAction: onRetry,
      iconColor: Theme.of(context).colorScheme.error,
    );
  }
}

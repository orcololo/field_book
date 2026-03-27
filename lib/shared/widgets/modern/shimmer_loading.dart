import 'package:flutter/material.dart';
import '../../../core/theme/folium_theme.dart';

/// Shimmer loading effect with organic pulse animation
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
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
    if (!widget.isLoading) {
      return widget.child;
    }

    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surfaceContainerHighest,
                colorScheme.surfaceContainer,
                colorScheme.surfaceContainerHighest,
              ],
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Predefined shimmer placeholders
class ShimmerPlaceholders {
  ShimmerPlaceholders._();

  static Widget plantCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: FoliumTheme.space16,
        vertical: FoliumTheme.space8,
      ),
      decoration: FoliumTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: FoliumTheme.surfaceVariant,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(FoliumTheme.radiusMedium),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(FoliumTheme.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: FoliumTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: FoliumTheme.space8),
                // Subtitle
                Container(
                  width: 150,
                  height: 16,
                  decoration: BoxDecoration(
                    color: FoliumTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: FoliumTheme.space12),
                // Metadata
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 14,
                      decoration: BoxDecoration(
                        color: FoliumTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        color: FoliumTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget listItem() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: FoliumTheme.space16,
        vertical: FoliumTheme.space4,
      ),
      padding: const EdgeInsets.all(FoliumTheme.space16),
      decoration: FoliumTheme.cardDecoration(shadows: FoliumTheme.elevation1),
      child: Row(
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: FoliumTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
            ),
          ),
          const SizedBox(width: FoliumTheme.space16),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: FoliumTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: FoliumTheme.space8),
                Container(
                  width: 100,
                  height: 14,
                  decoration: BoxDecoration(
                    color: FoliumTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget gridItem() {
    return Container(
      decoration: FoliumTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: FoliumTheme.surfaceVariant,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(FoliumTheme.radiusMedium),
                ),
              ),
            ),
          ),
          // Text
          Padding(
            padding: const EdgeInsets.all(FoliumTheme.space12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 14,
                  decoration: BoxDecoration(
                    color: FoliumTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: FoliumTheme.space4),
                Container(
                  width: 60,
                  height: 12,
                  decoration: BoxDecoration(
                    color: FoliumTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/folium_theme.dart';

/// Glassmorphic app bar with frosted effect and Folium branding
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;

  const GlassAppBar({
    super.key,
    this.actions,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                FoliumTheme.surface.withValues(alpha: 0.7),
                FoliumTheme.surface.withValues(alpha: 0.5),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: FoliumTheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FoliumTheme.space16,
                vertical: FoliumTheme.space8,
              ),
              child: Row(
                children: [
                  // Back button or logo
                  if (showBackButton)
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: FoliumTheme.onSurface,
                      ),
                      onPressed: onBack ?? () => Navigator.of(context).pop(),
                    )
                  else
                    _buildLogo(context),
                  
                  const Spacer(),
                  
                  // Actions
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Row(
      children: [
        // Leaf icon with gradient background
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: FoliumTheme.primaryMain.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
            boxShadow: [
              BoxShadow(
                color: FoliumTheme.primaryMain.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
            child: SvgPicture.asset(
              'leaf_icon.svg',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: FoliumTheme.space12),
        // App name with gradient text
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              FoliumTheme.primaryMain,
              FoliumTheme.primaryMain.withValues(alpha: 0.8),
            ],
          ).createShader(bounds),
          child: Text(
            'Folium',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}

/// Alternative glass app bar with more prominent frosted effect
class GlassAppBarFrosted extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String? title;
  final Widget? leading;
  final bool showBackButton;

  const GlassAppBarFrosted({
    super.key,
    this.actions,
    this.title,
    this.leading,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.8),
                Colors.white.withValues(alpha: 0.6),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: FoliumTheme.primaryMain.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FoliumTheme.space16,
                vertical: FoliumTheme.space8,
              ),
              child: Row(
                children: [
                  if (leading != null)
                    leading!
                  else if (showBackButton)
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: FoliumTheme.primaryMain.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: FoliumTheme.primaryMain,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  
                  if (title != null) ...[
                    if (showBackButton) const SizedBox(width: FoliumTheme.space8),
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: FoliumTheme.onSurface,
                          ),
                    ),
                  ] else
                    _buildBranding(context),
                  
                  const Spacer(),
                  
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranding(BuildContext context) {
    return Row(
      children: [
        // Icon with glass effect
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: FoliumTheme.primaryMain.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
            boxShadow: [
              BoxShadow(
                color: FoliumTheme.primaryMain.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
            child: SvgPicture.asset(
              'leaf_icon.svg',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: FoliumTheme.space10),
        // App name
        Text(
          'Folium',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: FoliumTheme.primaryMain,
                shadows: [
                  Shadow(
                    color: FoliumTheme.primaryMain.withValues(alpha: 0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
        ),
      ],
    );
  }
}

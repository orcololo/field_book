// ignore_for_file: use_null_aware_elements
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/folium_theme.dart';

/// Modern app bar with scroll-based transparency
class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool centerTitle;
  final Widget? bottom;
  final double? bottomHeight;

  const ModernAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBack,
    this.centerTitle = false,
    this.bottom,
    this.bottomHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        64.0 + (bottomHeight ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                  tooltip: 'Voltar',
                )
              : null),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: FoliumTheme.onSurface,
            ),
      ),
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight ?? 48),
              child: bottom!,
            )
          : null,
    );
  }
}

/// Modern search bar widget
class ModernSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Widget? leading;
  final List<Widget>? actions;

  const ModernSearchBar({
    super.key,
    this.hintText = 'Buscar...',
    this.controller,
    this.onChanged,
    this.onClear,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: FoliumTheme.space16,
        vertical: FoliumTheme.space8,
      ),
      decoration: BoxDecoration(
        color: FoliumTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(FoliumTheme.radiusMedium),
        boxShadow: FoliumTheme.elevation1,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: FoliumTheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
          prefixIcon: leading ??
              const Icon(
                Icons.search,
                color: FoliumTheme.onSurfaceVariant,
              ),
          suffixIcon: controller?.text.isNotEmpty == true
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: onClear,
                  color: FoliumTheme.onSurfaceVariant,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: FoliumTheme.space16,
            vertical: FoliumTheme.space12,
          ),
        ),
      ),
    );
  }
}

/// Section header widget
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FoliumTheme.space16,
        FoliumTheme.space24,
        FoliumTheme.space16,
        FoliumTheme.space12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: FoliumTheme.onSurface,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: FoliumTheme.space4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: FoliumTheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
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

  static Widget noPlants({VoidCallback? onAddPlant}) {
    return EmptyStateWidget(
      icon: Icons.eco,
      title: 'Nenhuma planta registrada',
      message: 'Comece sua coleção adicionando a primeira planta',
      actionLabel: 'Adicionar Planta',
      onAction: onAddPlant,
    );
  }

  static Widget noSessions({VoidCallback? onCreateSession}) {
    return EmptyStateWidget(
      icon: Icons.explore,
      title: 'Nenhuma sessão de coleta',
      message: 'Crie uma sessão para organizar suas coletas de campo',
      actionLabel: 'Nova Sessão',
      onAction: onCreateSession,
      iconColor: FoliumTheme.tertiaryMain,
    );
  }

  static Widget noResults({String? query}) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'Nenhum resultado encontrado',
      message: query != null
          ? 'Não encontramos resultados para "$query"'
          : 'Tente ajustar os filtros de busca',
      iconColor: FoliumTheme.warning,
    );
  }

  static Widget noPhotos() {
    return const EmptyStateWidget(
      icon: Icons.photo_library_outlined,
      title: 'Sem fotos',
      message: 'Adicione fotos para documentar esta planta',
    );
  }

  static Widget noMeasurements() {
    return const EmptyStateWidget(
      icon: Icons.straighten,
      title: 'Sem medições',
      message: 'Registre medições para análise científica',
    );
  }

  static Widget error({required String message, VoidCallback? onRetry}) {
    return EmptyStateWidget(
      icon: Icons.error_outline,
      title: 'Ops! Algo deu errado',
      message: message,
      actionLabel: onRetry != null ? 'Tentar Novamente' : null,
      onAction: onRetry,
      iconColor: FoliumTheme.error,
    );
  }
}

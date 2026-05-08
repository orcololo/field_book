import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/rain_mode_provider.dart';

class RainModeGuard extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onConfirmed;
  final bool enabled;
  final String actionLabel;
  final String overlayTitle;
  final String overlayMessage;
  final String unlockHint;
  final String unlockAlternativeHint;
  final String confirmTitle;
  final String confirmMessage;
  final String cancelLabel;
  final String confirmLabel;
  final String Function(int seconds) countdownLabel;
  final Color? confirmColor;

  const RainModeGuard({
    super.key,
    required this.child,
    required this.actionLabel,
    required this.overlayTitle,
    required this.overlayMessage,
    required this.unlockHint,
    required this.unlockAlternativeHint,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.countdownLabel,
    this.onConfirmed,
    this.enabled = true,
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rainModeEnabled = ref.watch(rainModeEnabledProvider);

    if (!enabled || onConfirmed == null || !rainModeEnabled) {
      return child;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final confirmed = await confirmDestructiveAction(
          context: context,
          rainModeEnabled: rainModeEnabled,
          actionLabel: actionLabel,
          overlayTitle: overlayTitle,
          overlayMessage: overlayMessage,
          unlockHint: unlockHint,
          unlockAlternativeHint: unlockAlternativeHint,
          confirmTitle: confirmTitle,
          confirmMessage: confirmMessage,
          cancelLabel: cancelLabel,
          confirmLabel: confirmLabel,
          countdownLabel: countdownLabel,
          confirmColor: confirmColor,
        );

        if (confirmed && context.mounted) {
          onConfirmed?.call();
        }
      },
      child: AbsorbPointer(child: child),
    );
  }

  static Future<bool> confirmDestructiveAction({
    required BuildContext context,
    required bool rainModeEnabled,
    required String actionLabel,
    required String overlayTitle,
    required String overlayMessage,
    required String unlockHint,
    required String unlockAlternativeHint,
    required String confirmTitle,
    required String confirmMessage,
    required String cancelLabel,
    required String confirmLabel,
    required String Function(int seconds) countdownLabel,
    Color? confirmColor,
  }) async {
    if (!rainModeEnabled) {
      return true;
    }

    final unlocked = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: actionLabel,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => _RainModeUnlockOverlay(
        overlayTitle: overlayTitle,
        overlayMessage: overlayMessage,
        unlockHint: unlockHint,
        unlockAlternativeHint: unlockAlternativeHint,
        cancelLabel: cancelLabel,
      ),
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(scale: Tween(begin: 0.96, end: 1.0).animate(curved), child: child),
        );
      },
    );

    if (unlocked != true || !context.mounted) {
      return false;
    }

    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => _RainModeCountdownDialog(
            title: confirmTitle,
            message: confirmMessage,
            cancelLabel: cancelLabel,
            confirmLabel: confirmLabel,
            countdownLabel: countdownLabel,
            confirmColor: confirmColor,
          ),
        ) ??
        false;
  }
}

class _RainModeUnlockOverlay extends StatefulWidget {
  final String overlayTitle;
  final String overlayMessage;
  final String unlockHint;
  final String unlockAlternativeHint;
  final String cancelLabel;

  const _RainModeUnlockOverlay({
    required this.overlayTitle,
    required this.overlayMessage,
    required this.unlockHint,
    required this.unlockAlternativeHint,
    required this.cancelLabel,
  });

  @override
  State<_RainModeUnlockOverlay> createState() => _RainModeUnlockOverlayState();
}

class _RainModeUnlockOverlayState extends State<_RainModeUnlockOverlay> {
  Timer? _holdTimer;
  int _tapCount = 0;
  bool _holding = false;

  void _startHold() {
    _holdTimer?.cancel();
    setState(() => _holding = true);
    _holdTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    });
  }

  void _cancelHold() {
    _holdTimer?.cancel();
    if (_holding && mounted) {
      setState(() => _holding = false);
    }
  }

  void _registerTap() {
    setState(() {
      _tapCount += 1;
    });

    if (_tapCount >= 3) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.14),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🌧️', style: TextStyle(fontSize: 34)),
                  const SizedBox(height: 12),
                  Text(
                    widget.overlayTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.overlayMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _registerTap,
                    onTapDown: (_) => _startHold(),
                    onTapUp: (_) => _cancelHold(),
                    onTapCancel: _cancelHold,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 148,
                      height: 148,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            colorScheme.primary.withValues(
                              alpha: _holding ? 0.34 : 0.22,
                            ),
                            colorScheme.primary.withValues(alpha: 0.08),
                          ],
                        ),
                        border: Border.all(
                          color: colorScheme.primary.withValues(
                            alpha: _holding ? 0.7 : 0.32,
                          ),
                          width: _holding ? 3 : 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.water_drop_outlined,
                            size: 40,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _holding ? '2s' : '1 / 3',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _holding ? widget.unlockHint : '${_tapCount.clamp(0, 3)}/3',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.unlockHint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.unlockAlternativeHint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(widget.cancelLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RainModeCountdownDialog extends StatefulWidget {
  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final String Function(int seconds) countdownLabel;
  final Color? confirmColor;

  const _RainModeCountdownDialog({
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.countdownLabel,
    this.confirmColor,
  });

  @override
  State<_RainModeCountdownDialog> createState() =>
      _RainModeCountdownDialogState();
}

class _RainModeCountdownDialogState extends State<_RainModeCountdownDialog> {
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = 3;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
        return;
      }

      setState(() => _secondsRemaining -= 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.message),
          const SizedBox(height: 12),
          AnimatedOpacity(
            opacity: _secondsRemaining == 0 ? 0.55 : 1,
            duration: const Duration(milliseconds: 180),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
        child: Text(
          widget.countdownLabel(_secondsRemaining),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(widget.cancelLabel),
        ),
        FilledButton(
          onPressed: _secondsRemaining == 0
              ? () => Navigator.of(context).pop(true)
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: widget.confirmColor ?? colorScheme.error,
          ),
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

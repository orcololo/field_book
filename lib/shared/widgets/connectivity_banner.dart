import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/connectivity_provider.dart';

/// A thin banner that slides in at the top when the device is offline.
/// Designed to be placed inside a MaterialApp builder so it appears on all screens.
class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineValueProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isOnline ? 0 : 32,
      color: Colors.red.shade700,
      child: isOnline
          ? const SizedBox.shrink()
          : Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, color: Colors.white, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    'Sem conexão',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/app_update_provider.dart';
import '../../core/providers/connectivity_provider.dart';
import '../../core/services/app_update_service.dart';
import '../../l10n/app_localizations.dart';

class AppUpdateBanner extends ConsumerStatefulWidget {
  const AppUpdateBanner({super.key});

  @override
  ConsumerState<AppUpdateBanner> createState() => _AppUpdateBannerState();
}

class _AppUpdateBannerState extends ConsumerState<AppUpdateBanner> {
  bool _checkedCurrentOnlineSession = false;

  bool get _supportsApkUpdates =>
      defaultTargetPlatform == TargetPlatform.android;

  void _scheduleUpdateCheck() {
    Future.microtask(() {
      if (!mounted) return;
      if (ref.read(isOnlineValueProvider)) {
        ref.read(appUpdateNotifierProvider.notifier).checkForUpdates();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_supportsApkUpdates) return const SizedBox.shrink();

    final isOnline = ref.watch(isOnlineValueProvider);
    if (isOnline && !_checkedCurrentOnlineSession) {
      _checkedCurrentOnlineSession = true;
      _scheduleUpdateCheck();
    } else if (!isOnline) {
      _checkedCurrentOnlineSession = false;
    }

    final state = ref.watch(appUpdateNotifierProvider);
    final release = state.availableRelease;
    if (!isOnline || release == null) return const SizedBox.shrink();

    return TestableAppUpdateBanner(
      release: release,
      onOpen: () async {
        await launchUrl(
          release.downloadUrl,
          mode: LaunchMode.externalApplication,
        );
      },
      onDismiss: () {
        ref.read(appUpdateNotifierProvider.notifier).dismissCurrentUpdate();
      },
    );
  }
}

class TestableAppUpdateBanner extends StatelessWidget {
  final AppReleaseInfo release;
  final VoidCallback onOpen;
  final VoidCallback onDismiss;

  const TestableAppUpdateBanner({
    super.key,
    required this.release,
    required this.onOpen,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = l10n == null
        ? 'Nova versão disponível: ${release.versionLabel}'
        : l10n.appUpdateAvailable(release.versionLabel);
    final downloadLabel = l10n?.appUpdateDownloadAction ?? 'Baixar';
    final dismissLabel = l10n?.appUpdateDismissAction ?? 'Depois';

    return MaterialBanner(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      leading: Icon(
        Icons.system_update_alt,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      content: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      actions: [
        TextButton(onPressed: onDismiss, child: Text(dismissLabel)),
        TextButton(onPressed: onOpen, child: Text(downloadLabel)),
      ],
    );
  }
}

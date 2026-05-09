import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/settings_service.dart';
import '../../../core/theme/folium_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/modern/modern_app_bar.dart';

class InaturalistAuthScreen extends ConsumerStatefulWidget {
  const InaturalistAuthScreen({super.key});

  @override
  ConsumerState<InaturalistAuthScreen> createState() =>
      _InaturalistAuthScreenState();
}

class _InaturalistAuthScreenState extends ConsumerState<InaturalistAuthScreen> {
  final _tokenController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final settings = await ref.read(settingsNotifierProvider.future);
      if (!mounted) return;
      _tokenController.text = settings.inatAccessToken ?? '';
      _usernameController.text = settings.inatUsername ?? '';
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ModernAppBar(title: l10n.inaturalistAuthTitle),
      body: ListView(
        padding: const EdgeInsets.all(FoliumTheme.space16),
        children: [
          Container(
            padding: const EdgeInsets.all(FoliumTheme.space16),
            decoration: FoliumTheme.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.inaturalistTokenSetupTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: FoliumTheme.space8),
                Text(
                  l10n.inaturalistTokenSetupDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: FoliumTheme.space16),
                OutlinedButton.icon(
                  onPressed: _openTokenPage,
                  icon: const Icon(Icons.open_in_browser),
                  label: Text(l10n.inaturalistOpenTokenPage),
                ),
              ],
            ),
          ),
          const SizedBox(height: FoliumTheme.space16),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: l10n.inaturalistUsername,
              hintText: l10n.inaturalistUsernameHint,
            ),
          ),
          const SizedBox(height: FoliumTheme.space16),
          TextField(
            controller: _tokenController,
            maxLines: 4,
            minLines: 3,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.inaturalistAccessToken,
              hintText: l10n.inaturalistAccessTokenHint,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: FoliumTheme.space12),
          Text(
            l10n.inaturalistTokenHelp,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: FoliumTheme.space24),
          FilledButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.verified_user_outlined),
            label: Text(
              _isSaving ? l10n.saving : l10n.inaturalistSaveCredentials,
            ),
          ),
          const SizedBox(height: FoliumTheme.space12),
          TextButton.icon(
            onPressed: _isSaving ? null : _clear,
            icon: const Icon(Icons.delete_outline),
            label: Text(l10n.inaturalistClearCredentials),
          ),
        ],
      ),
    );
  }

  Future<void> _openTokenPage() async {
    final l10n = AppLocalizations.of(context)!;
    final uri = Uri.parse('https://www.inaturalist.org/users/api_token');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.inaturalistPushError(uri.toString()))),
      );
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSaving = true);

    try {
      await ref.read(settingsNotifierProvider.notifier).setInaturalistCredentials(
        accessToken: _tokenController.text,
        username: _usernameController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.inaturalistCredentialsSaved)),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.inaturalistPushError(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _clear() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      await ref.read(settingsNotifierProvider.notifier).setInaturalistCredentials(
        accessToken: null,
        username: null,
      );

      _tokenController.clear();
      _usernameController.clear();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.inaturalistCredentialsCleared)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.inaturalistPushError(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

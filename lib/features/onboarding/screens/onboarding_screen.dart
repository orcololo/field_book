import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/theme/folium_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/screens/home_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _initialsController = TextEditingController(text: 'RC');
  final _lastNumberController = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    // Load current values if returning from settings "Show Tutorial"
    final settings = ref.read(settingsNotifierProvider).valueOrNull;
    if (settings != null) {
      _initialsController.text = settings.userInitials;
      _lastNumberController.text = settings.lastRegistryNumber.toString();
    }
    _initialsController.addListener(_onFieldChanged);
    _lastNumberController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() => setState(() {});

  @override
  void dispose() {
    _initialsController.removeListener(_onFieldChanged);
    _lastNumberController.removeListener(_onFieldChanged);
    _initialsController.dispose();
    _lastNumberController.dispose();
    super.dispose();
  }

  String get _previewIdentifier {
    final initials = _initialsController.text.trim().toUpperCase();
    final lastNum = int.tryParse(_lastNumberController.text.trim()) ?? 0;
    final next = lastNum + 1;
    return '$initials${next.toString().padLeft(6, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return IntroductionScreen(
      globalBackgroundColor: FoliumTheme.surface,
      pages: [
        _buildPage(
          title: l10n.onboardingWelcomeTitle,
          body: l10n.onboardingWelcomeBody,
          icon: Icons.eco_outlined,
          gradientColors: [
            FoliumTheme.primaryMain,
            FoliumTheme.success,
          ],
          context: context,
        ),
        _buildPage(
          title: l10n.onboardingSessionsTitle,
          body: l10n.onboardingSessionsBody,
          icon: Icons.folder_outlined,
          gradientColors: [
            FoliumTheme.secondaryMain,
            FoliumTheme.secondaryContainer,
          ],
          context: context,
        ),
        _buildPage(
          title: l10n.onboardingCollectionTitle,
          body: l10n.onboardingCollectionBody,
          icon: Icons.camera_alt_outlined,
          gradientColors: [
            FoliumTheme.tertiaryMain,
            FoliumTheme.tertiaryContainer,
          ],
          context: context,
        ),
        _buildPage(
          title: l10n.onboardingExportTitle,
          body: l10n.onboardingExportBody,
          icon: Icons.upload_file_outlined,
          gradientColors: [
            FoliumTheme.primaryMain,
            FoliumTheme.primaryContainer,
          ],
          context: context,
        ),
        // Setup page — user initials & last registry number
        _buildSetupPage(context, l10n),
      ],
      showSkipButton: true,
      skip: Text(
        l10n.onboardingSkip,
        style: TextStyle(
          color: FoliumTheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
      next: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: FoliumTheme.space20,
          vertical: FoliumTheme.space12,
        ),
        decoration: BoxDecoration(
          color: FoliumTheme.primaryMain,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
        ),
        child: Text(
          l10n.onboardingNext,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      done: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: FoliumTheme.space24,
          vertical: FoliumTheme.space12,
        ),
        decoration: BoxDecoration(
          color: FoliumTheme.primaryMain,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
        ),
        child: Text(
          l10n.onboardingDone,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onDone: () => _completeOnboarding(context),
      onSkip: () => _completeOnboarding(context),
      dotsDecorator: DotsDecorator(
        size: const Size(8.0, 8.0),
        color: FoliumTheme.primaryMain.withValues(alpha: 0.2),
        activeSize: const Size(22.0, 8.0),
        activeColor: FoliumTheme.primaryMain,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
        ),
      ),
      animationDuration: FoliumTheme.durationNormal.inMilliseconds,
      curve: Curves.easeInOut,
    );
  }

  PageViewModel _buildSetupPage(BuildContext context, AppLocalizations l10n) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.only(top: FoliumTheme.space24),
        child: Text(
          l10n.onboardingSetupTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: FoliumTheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
          textAlign: TextAlign.center,
        ),
      ),
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FoliumTheme.space24),
        child: Column(
          children: [
            Text(
              l10n.onboardingSetupBody,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: FoliumTheme.onSurfaceVariant,
                    height: 1.6,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: FoliumTheme.space32),

            // Initials field
            TextField(
              controller: _initialsController,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: InputDecoration(
                labelText: l10n.onboardingInitialsLabel,
                hintText: l10n.onboardingInitialsHint,
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(FoliumTheme.radiusMedium),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(FoliumTheme.radiusMedium),
                  borderSide: const BorderSide(
                    color: FoliumTheme.primaryMain,
                    width: 2,
                  ),
                ),
              ),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: FoliumTheme.space16),

            // Last number field
            TextField(
              controller: _lastNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: InputDecoration(
                labelText: l10n.onboardingLastNumberLabel,
                hintText: l10n.onboardingLastNumberHint,
                prefixIcon: const Icon(Icons.tag),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(FoliumTheme.radiusMedium),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(FoliumTheme.radiusMedium),
                  borderSide: const BorderSide(
                    color: FoliumTheme.primaryMain,
                    width: 2,
                  ),
                ),
              ),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: FoliumTheme.space24),

            // Preview chip
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FoliumTheme.space20,
                vertical: FoliumTheme.space12,
              ),
              decoration: BoxDecoration(
                color: FoliumTheme.primaryContainer,
                borderRadius:
                    BorderRadius.circular(FoliumTheme.radiusFull),
              ),
              child: Text(
                l10n.onboardingIdentifierPreview(_previewIdentifier),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: FoliumTheme.primaryMain,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
              ),
            ),
          ],
        ),
      ),
      image: Center(
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                FoliumTheme.secondaryMain,
                FoliumTheme.primaryMain,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: FoliumTheme.secondaryMain.withValues(alpha: 0.3),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.assignment_ind_outlined,
            size: 80,
            color: Colors.white,
          ),
        ),
      ),
      decoration: PageDecoration(
        imagePadding: const EdgeInsets.only(top: FoliumTheme.space48),
        contentMargin: const EdgeInsets.symmetric(
          horizontal: FoliumTheme.space16,
        ),
        bodyPadding: const EdgeInsets.only(top: FoliumTheme.space16),
      ),
    );
  }

  PageViewModel _buildPage({
    required String title,
    required String body,
    required IconData icon,
    required List<Color> gradientColors,
    required BuildContext context,
  }) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.only(top: FoliumTheme.space24),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: FoliumTheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
          textAlign: TextAlign.center,
        ),
      ),
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FoliumTheme.space24),
        child: Text(
          body,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: FoliumTheme.onSurfaceVariant,
                height: 1.6,
              ),
          textAlign: TextAlign.center,
        ),
      ),
      image: Center(
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withValues(alpha: 0.3),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 80,
            color: Colors.white,
          ),
        ),
      ),
      decoration: PageDecoration(
        imagePadding: const EdgeInsets.only(top: FoliumTheme.space64),
        contentMargin: const EdgeInsets.symmetric(
          horizontal: FoliumTheme.space16,
        ),
        bodyPadding: const EdgeInsets.only(top: FoliumTheme.space16),
      ),
    );
  }

  void _completeOnboarding(BuildContext context) async {
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final settings = ref.read(settingsNotifierProvider).valueOrNull;

    if (settings != null) {
      final initials = _initialsController.text.trim().toUpperCase();
      final lastNumber =
          int.tryParse(_lastNumberController.text.trim()) ?? 0;

      settings
        ..userInitials = initials.isNotEmpty ? initials : 'RC'
        ..lastRegistryNumber = lastNumber
        ..hasCompletedOnboarding = true;
      await notifier.updateSettings(settings);
    } else {
      await notifier.setHasCompletedOnboarding(true);
    }

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }
}

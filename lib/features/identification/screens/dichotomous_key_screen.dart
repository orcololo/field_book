import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/dichotomous_key_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/modern/modern_app_bar.dart';

class DichotomousKeyScreen extends ConsumerStatefulWidget {
  const DichotomousKeyScreen({super.key});

  @override
  ConsumerState<DichotomousKeyScreen> createState() =>
      _DichotomousKeyScreenState();
}

class _DichotomousKeyScreenState extends ConsumerState<DichotomousKeyScreen> {
  final List<_AnsweredStep> _trail = [];

  void _answerQuestion(
    Map<String, DichotomousKey> keys,
    DichotomousKeyRoute currentRoute,
    DichotomousKeyStep currentStep,
    bool answerYes,
  ) {
    setState(() {
      _trail.add(
        _AnsweredStep(
          route: currentRoute,
          question: currentStep.question,
          answerYes: answerYes,
        ),
      );
    });
  }

  void _goBackStep() {
    if (_trail.isEmpty) return;

    setState(() {
      _trail.removeLast();
    });
  }

  void _restart() {
    setState(_trail.clear);
  }

  _ScreenState _deriveState(Map<String, DichotomousKey> keys) {
    final service = ref.read(dichotomousKeyServiceProvider);
    var route = service.initialRoute(keys);
    String? resultFamily;

    for (final entry in _trail) {
      final currentKey = keys[route.family]!;
      final currentStep = currentKey.stepById[route.stepId]!;
      final transition = service.resolveAnswer(
        keys: keys,
        currentRoute: route,
        answerYes: entry.answerYes,
      );

      if (transition.resultFamily != null) {
        resultFamily = transition.resultFamily;
        break;
      }

      route = transition.nextRoute!;

      if (entry.route.family != currentKey.family ||
          entry.route.stepId != currentStep.id) {
        break;
      }
    }

    return _ScreenState(currentRoute: route, resultFamily: resultFamily);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final keysAsync = ref.watch(dichotomousKeysProvider);

    return Scaffold(
      appBar: ModernAppBar(
        title: l10n.dichotomousKeyTitle,
        actions: [
          IconButton(
            onPressed: _trail.isEmpty ? null : _restart,
            icon: const Icon(Icons.refresh),
            tooltip: l10n.dichotomousKeyRestart,
          ),
        ],
      ),
      body: keysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.dichotomousKeyLoadError(error.toString()),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(dichotomousKeysProvider),
                  child: Text(l10n.tryAgain),
                ),
              ],
            ),
          ),
        ),
        data: (keys) {
          if (keys.isEmpty) {
            return Center(child: Text(l10n.dichotomousKeyEmpty));
          }

          final screenState = _deriveState(keys);
          final currentRoute = screenState.currentRoute;
          final currentKey = keys[currentRoute.family]!;
          final currentStep = currentKey.stepById[currentRoute.stepId]!;
          final currentBranchLabel = currentKey.family ==
                  DichotomousKeyService.generalKeyFamily
              ? l10n.dichotomousKeyGeneralBranch
              : currentKey.family;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dichotomousKeyHowToUse,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.dichotomousKeyIntro),
                    ],
                  ),
                ),
              ),
              if (_trail.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.dichotomousKeyTrail,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _trail.asMap().entries.map((entry) {
                      final item = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(
                          right: entry.key == _trail.length - 1 ? 0 : 8,
                        ),
                        child: Chip(
                          label: Text(
                            '${entry.key + 1}. ${item.question} • ${item.answerYes ? l10n.yes : l10n.no}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(growable: false),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (screenState.resultFamily != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.dichotomousKeySuggestedFamily,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          screenState.resultFamily!,
                          style:
                              Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(l10n.dichotomousKeyResultHelp),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => Navigator.pop(
                            context,
                            screenState.resultFamily,
                          ),
                          icon: const Icon(Icons.check_circle_outline),
                          label: Text(l10n.dichotomousKeyUseFamily),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.dichotomousKeyCurrentBranch(currentBranchLabel),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.dichotomousKeyQuestionCounter(_trail.length + 1),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentStep.question,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => _answerQuestion(
                                  keys,
                                  currentRoute,
                                  currentStep,
                                  true,
                                ),
                                icon: const Icon(Icons.check),
                                label: Text(l10n.yes),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _answerQuestion(
                                  keys,
                                  currentRoute,
                                  currentStep,
                                  false,
                                ),
                                icon: const Icon(Icons.close),
                                label: Text(l10n.no),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _trail.isEmpty ? null : _goBackStep,
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n.dichotomousKeyBackStep),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AnsweredStep {
  const _AnsweredStep({
    required this.route,
    required this.question,
    required this.answerYes,
  });

  final DichotomousKeyRoute route;
  final String question;
  final bool answerYes;
}

class _ScreenState {
  const _ScreenState({required this.currentRoute, this.resultFamily});

  final DichotomousKeyRoute currentRoute;
  final String? resultFamily;
}

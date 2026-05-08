import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dichotomousKeyServiceProvider = Provider<DichotomousKeyService>((ref) {
  return const DichotomousKeyService();
});

final dichotomousKeysProvider =
    FutureProvider<Map<String, DichotomousKey>>((ref) async {
      return ref.read(dichotomousKeyServiceProvider).loadKeys();
    });

class DichotomousKeyService {
  const DichotomousKeyService();

  static const String assetPath = 'assets/data/dichotomous_keys.json';
  static const String generalKeyFamily = 'general';

  Future<Map<String, DichotomousKey>> loadKeys() async {
    final rawJson = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(rawJson);

    if (decoded is! List) {
      throw const FormatException('Invalid dichotomous keys payload.');
    }

    final keys = decoded
        .map((entry) => DichotomousKey.fromJson(entry as Map<String, dynamic>))
        .toList(growable: false);

    return {for (final key in keys) key.family: key};
  }

  DichotomousKeyRoute initialRoute(Map<String, DichotomousKey> keys) {
    final generalKey = keys[generalKeyFamily];
    if (generalKey == null) {
      throw const FormatException('General dichotomous key was not found.');
    }

    return DichotomousKeyRoute(
      family: generalKey.family,
      stepId: generalKey.initialStep.id,
    );
  }

  DichotomousKeyTransition resolveAnswer({
    required Map<String, DichotomousKey> keys,
    required DichotomousKeyRoute currentRoute,
    required bool answerYes,
  }) {
    final currentKey = keys[currentRoute.family];
    if (currentKey == null) {
      throw FormatException('Key not found for family ${currentRoute.family}.');
    }

    final currentStep = currentKey.stepById[currentRoute.stepId];
    if (currentStep == null) {
      throw FormatException(
        'Step ${currentRoute.stepId} not found in key ${currentRoute.family}.',
      );
    }

    final target = answerYes ? currentStep.ifYes : currentStep.ifNo;

    if (currentKey.stepById.containsKey(target)) {
      return DichotomousKeyTransition(
        nextRoute: DichotomousKeyRoute(
          family: currentKey.family,
          stepId: target,
        ),
      );
    }

    if (target == currentKey.family) {
      return DichotomousKeyTransition(resultFamily: target);
    }

    final targetKey = keys[target];
    if (targetKey != null) {
      return DichotomousKeyTransition(
        nextRoute: DichotomousKeyRoute(
          family: targetKey.family,
          stepId: targetKey.initialStep.id,
        ),
      );
    }

    return DichotomousKeyTransition(resultFamily: target);
  }
}

class DichotomousKey {
  const DichotomousKey({required this.family, required this.steps});

  factory DichotomousKey.fromJson(Map<String, dynamic> json) {
    final stepsJson = json['steps'];
    if (stepsJson is! List || stepsJson.isEmpty) {
      throw FormatException('Key ${json['family']} has no steps.');
    }

    return DichotomousKey(
      family: json['family'] as String,
      steps: stepsJson
          .map(
            (step) =>
                DichotomousKeyStep.fromJson(step as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  final String family;
  final List<DichotomousKeyStep> steps;

  DichotomousKeyStep get initialStep => steps.first;

  Map<String, DichotomousKeyStep> get stepById => {
    for (final step in steps) step.id: step,
  };
}

class DichotomousKeyStep {
  const DichotomousKeyStep({
    required this.id,
    required this.question,
    required this.ifYes,
    required this.ifNo,
  });

  factory DichotomousKeyStep.fromJson(Map<String, dynamic> json) {
    return DichotomousKeyStep(
      id: json['id'] as String,
      question: json['question'] as String,
      ifYes: json['ifYes'] as String,
      ifNo: json['ifNo'] as String,
    );
  }

  final String id;
  final String question;
  final String ifYes;
  final String ifNo;
}

class DichotomousKeyRoute {
  const DichotomousKeyRoute({required this.family, required this.stepId});

  final String family;
  final String stepId;
}

class DichotomousKeyTransition {
  const DichotomousKeyTransition({this.nextRoute, this.resultFamily});

  final DichotomousKeyRoute? nextRoute;
  final String? resultFamily;
}

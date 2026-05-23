import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/plant_category.dart';

extension PlantCategoryPresentation on PlantCategory {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case PlantCategory.samambaia:
        return l10n.categorySamambaia;
      case PlantCategory.erva:
        return l10n.categoryErva;
      case PlantCategory.semi_arbusto:
        return l10n.categorySemiArbusto;
      case PlantCategory.arbusto:
        return l10n.categoryArbusto;
      case PlantCategory.arvore:
        return l10n.categoryArvore;
      case PlantCategory.erva_trepadeira:
        return l10n.categoryErvaTrepadeira;
      case PlantCategory.erva_epifita:
        return l10n.categoryErvaEpifita;
      case PlantCategory.hemiepifita:
        return l10n.categoryHemiepifita;
      case PlantCategory.prostrada:
        return l10n.categoryProstrada;
      case PlantCategory.rastejante:
        return l10n.categoryRastejante;
      case PlantCategory.planta_rupicola:
        return l10n.categoryPlantaRupicola;
      case PlantCategory.ciofila:
        return l10n.categoryCiofila;
      case PlantCategory.epilitica:
        return l10n.categoryEpilitica;
      case PlantCategory.trees:
        return l10n.categoryArvore;
      case PlantCategory.shrubs:
        return l10n.categoryArbusto;
      case PlantCategory.herbs:
        return l10n.categoryErva;
      case PlantCategory.ferns:
        return l10n.categorySamambaia;
      case PlantCategory.grasses:
        return l10n.categoryGrasses;
      case PlantCategory.vines:
        return l10n.categoryErvaTrepadeira;
      case PlantCategory.cacti:
        return l10n.categoryCacti;
      case PlantCategory.aquatic:
        return l10n.categoryAquatic;
    }
  }

  IconData get icon {
    switch (this) {
      case PlantCategory.arvore:
      case PlantCategory.trees:
        return Icons.park;
      case PlantCategory.arbusto:
      case PlantCategory.semi_arbusto:
      case PlantCategory.shrubs:
        return Icons.forest;
      case PlantCategory.erva:
      case PlantCategory.prostrada:
      case PlantCategory.rastejante:
      case PlantCategory.herbs:
      case PlantCategory.grasses:
        return Icons.grass;
      case PlantCategory.samambaia:
      case PlantCategory.erva_epifita:
      case PlantCategory.hemiepifita:
      case PlantCategory.ferns:
        return Icons.eco;
      case PlantCategory.erva_trepadeira:
      case PlantCategory.vines:
        return Icons.account_tree;
      case PlantCategory.planta_rupicola:
      case PlantCategory.epilitica:
      case PlantCategory.cacti:
        return Icons.terrain;
      case PlantCategory.ciofila:
        return Icons.filter_vintage;
      case PlantCategory.aquatic:
        return Icons.water;
    }
  }

  Color get chartColor {
    switch (this) {
      case PlantCategory.samambaia:
      case PlantCategory.ferns:
        return Colors.teal;
      case PlantCategory.erva:
      case PlantCategory.herbs:
        return Colors.lightGreen;
      case PlantCategory.semi_arbusto:
      case PlantCategory.arbusto:
      case PlantCategory.shrubs:
        return Colors.green;
      case PlantCategory.arvore:
      case PlantCategory.trees:
        return Colors.green.shade700;
      case PlantCategory.erva_trepadeira:
      case PlantCategory.vines:
        return Colors.deepOrange;
      case PlantCategory.erva_epifita:
      case PlantCategory.hemiepifita:
        return Colors.cyan;
      case PlantCategory.prostrada:
      case PlantCategory.rastejante:
      case PlantCategory.grasses:
        return Colors.lime;
      case PlantCategory.planta_rupicola:
      case PlantCategory.epilitica:
      case PlantCategory.cacti:
        return Colors.amber;
      case PlantCategory.ciofila:
        return Colors.indigo;
      case PlantCategory.aquatic:
        return Colors.blue;
    }
  }
}

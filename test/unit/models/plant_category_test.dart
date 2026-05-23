import 'package:field_book/models/plant_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlantCategory', () {
    const currentCategoryNames = [
      'samambaia',
      'erva',
      'semi_arbusto',
      'arbusto',
      'arvore',
      'erva_trepadeira',
      'erva_epifita',
      'hemiepifita',
      'prostrada',
      'rastejante',
      'planta_rupicola',
      'ciofila',
      'epilitica',
    ];

    const legacyCategoryNames = [
      'trees',
      'shrubs',
      'herbs',
      'ferns',
      'grasses',
      'vines',
      'cacti',
      'aquatic',
    ];

    test('exposes the official botanical categories for new selections', () {
      expect(
        PlantCategory.currentValues.map((category) => category.name),
        currentCategoryNames,
      );
    });

    test('keeps legacy sync values parseable but out of new selections', () {
      expect(
        PlantCategory.legacyValues.map((category) => category.name),
        legacyCategoryNames,
      );

      for (final categoryName in legacyCategoryNames) {
        expect(PlantCategory.fromName(categoryName)?.name, categoryName);
      }

      expect(
        PlantCategory.fromName('semi_arbusto'),
        PlantCategory.semi_arbusto,
      );
      expect(PlantCategory.fromName('unknown'), isNull);
      expect(
        PlantCategory.currentValues.map((category) => category.name),
        isNot(contains('trees')),
      );
    });
  });
}

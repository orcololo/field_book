// ignore_for_file: constant_identifier_names

enum PlantCategory {
  erva,
  samambaia,
  semi_arbusto,
  arbusto,
  arvore,
  erva_trepadeira,
  erva_epifita,
  hemiepifita,
  prostrada,
  rastejante,
  planta_rupicola,
  ciofila,
  epilitica,
  trees,
  shrubs,
  herbs,
  ferns,
  grasses,
  vines,
  cacti,
  aquatic;

  static const currentValues = [
    samambaia,
    erva,
    semi_arbusto,
    arbusto,
    arvore,
    erva_trepadeira,
    erva_epifita,
    hemiepifita,
    prostrada,
    rastejante,
    planta_rupicola,
    ciofila,
    epilitica,
  ];

  static const legacyValues = [
    trees,
    shrubs,
    herbs,
    ferns,
    grasses,
    vines,
    cacti,
    aquatic,
  ];

  static List<PlantCategory> optionsFor(PlantCategory? selected) {
    if (selected == null || currentValues.contains(selected)) {
      return currentValues;
    }
    return [...currentValues, selected];
  }

  static PlantCategory? fromName(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final category in values) {
      if (category.name == value) return category;
    }
    return null;
  }
}

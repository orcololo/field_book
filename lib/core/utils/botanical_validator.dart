import '../repositories/plant_repository.dart';

/// Service for botanical name validation and auto-suggestions
class BotanicalValidator {
  final PlantRepository _plantRepo;

  BotanicalValidator(this._plantRepo);

  // Common botanical families mapped to their typical genera
  static const Map<String, List<String>> familyToGenera = {
    'Fabaceae': ['Acacia', 'Mimosa', 'Bauhinia', 'Caesalpinia', 'Cassia'],
    'Asteraceae': ['Baccharis', 'Vernonia', 'Mikania', 'Eremanthus', 'Lychnophora'],
    'Myrtaceae': ['Eucalyptus', 'Eugenia', 'Psidium', 'Myrcia', 'Campomanesia'],
    'Rubiaceae': ['Psychotria', 'Palicourea', 'Coffea', 'Alibertia', 'Cordiera'],
    'Melastomataceae': ['Miconia', 'Leandra', 'Tibouchina', 'Lavoisiera', 'Trembleya'],
    'Lauraceae': ['Ocotea', 'Nectandra', 'Persea', 'Aniba', 'Cryptocarya'],
    'Arecaceae': ['Syagrus', 'Attalea', 'Euterpe', 'Geonoma', 'Bactris'],
    'Bromeliaceae': ['Tillandsia', 'Aechmea', 'Vriesea', 'Pitcairnia', 'Dyckia'],
    'Orchidaceae': ['Epidendrum', 'Oncidium', 'Cattleya', 'Maxillaria', 'Pleurothallis'],
    'Poaceae': ['Panicum', 'Paspalum', 'Axonopus', 'Andropogon', 'Eragrostis'],
    'Apocynaceae': ['Aspidosperma', 'Tabernaemontana', 'Mandevilla', 'Forsteronia', 'Prestonia'],
    'Bignoniaceae': ['Tabebuia', 'Handroanthus', 'Jacaranda', 'Anemopaegma', 'Fridericia'],
    'Solanaceae': ['Solanum', 'Cestrum', 'Capsicum', 'Nicotiana', 'Physalis'],
    'Euphorbiaceae': ['Croton', 'Euphorbia', 'Manihot', 'Sebastiania', 'Alchornea'],
    'Malvaceae': ['Hibiscus', 'Sida', 'Pavonia', 'Luehea', 'Triumfetta'],
  };

  // Common genera mapped to their families
  static const Map<String, String> genusToFamily = {
    'Acacia': 'Fabaceae',
    'Mimosa': 'Fabaceae',
    'Bauhinia': 'Fabaceae',
    'Caesalpinia': 'Fabaceae',
    'Cassia': 'Fabaceae',
    'Baccharis': 'Asteraceae',
    'Vernonia': 'Asteraceae',
    'Mikania': 'Asteraceae',
    'Eremanthus': 'Asteraceae',
    'Eucalyptus': 'Myrtaceae',
    'Eugenia': 'Myrtaceae',
    'Psidium': 'Myrtaceae',
    'Myrcia': 'Myrtaceae',
    'Psychotria': 'Rubiaceae',
    'Palicourea': 'Rubiaceae',
    'Coffea': 'Rubiaceae',
    'Miconia': 'Melastomataceae',
    'Leandra': 'Melastomataceae',
    'Tibouchina': 'Melastomataceae',
    'Ocotea': 'Lauraceae',
    'Nectandra': 'Lauraceae',
    'Persea': 'Lauraceae',
    'Syagrus': 'Arecaceae',
    'Attalea': 'Arecaceae',
    'Euterpe': 'Arecaceae',
    'Tillandsia': 'Bromeliaceae',
    'Aechmea': 'Bromeliaceae',
    'Vriesea': 'Bromeliaceae',
    'Epidendrum': 'Orchidaceae',
    'Oncidium': 'Orchidaceae',
    'Cattleya': 'Orchidaceae',
    'Panicum': 'Poaceae',
    'Paspalum': 'Poaceae',
    'Axonopus': 'Poaceae',
    'Aspidosperma': 'Apocynaceae',
    'Tabernaemontana': 'Apocynaceae',
    'Mandevilla': 'Apocynaceae',
    'Tabebuia': 'Bignoniaceae',
    'Handroanthus': 'Bignoniaceae',
    'Jacaranda': 'Bignoniaceae',
    'Solanum': 'Solanaceae',
    'Cestrum': 'Solanaceae',
    'Capsicum': 'Solanaceae',
    'Croton': 'Euphorbiaceae',
    'Euphorbia': 'Euphorbiaceae',
    'Manihot': 'Euphorbiaceae',
    'Hibiscus': 'Malvaceae',
    'Sida': 'Malvaceae',
    'Pavonia': 'Malvaceae',
  };

  /// Validates scientific name format (basic binomial nomenclature check)
  String? validateScientificName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Nome científico é obrigatório';
    }

    final trimmed = name.trim();
    
    // Check if it has at least 2 words (genus + species)
    final parts = trimmed.split(' ');
    if (parts.length < 2) {
      return 'Nome científico deve conter pelo menos gênero e espécie';
    }

    // Check if first letter is uppercase
    if (!RegExp(r'^[A-Z]').hasMatch(trimmed)) {
      return 'Nome do gênero deve começar com maiúscula';
    }

    // Check if contains only letters and spaces
    if (!RegExp(r'^[A-Za-z\s\-\.]+$').hasMatch(trimmed)) {
      return 'Nome científico deve conter apenas letras, espaços e hífens';
    }

    return null; // Valid
  }

  /// Suggests family based on genus
  String? suggestFamily(String genus) {
    final capitalizedGenus = genus.trim().split(' ').first;
    return genusToFamily[capitalizedGenus];
  }

  /// Gets genera suggestions for a family
  List<String> getGeneraForFamily(String family) {
    return familyToGenera[family] ?? [];
  }

  /// Checks for potential duplicate scientific names
  Future<List<String>> checkForDuplicates(String scientificName, {String? excludeId}) async {
    if (scientificName.trim().isEmpty) return [];

    try {
      // Search for similar scientific names
      final results = await _plantRepo.fullTextSearch(
        scientificName.trim(),
        limit: 5,
      );

      final duplicates = <String>[];
      for (final plant in results) {
        // Skip if it's the same plant being edited
        if (excludeId != null && plant.uuid == excludeId) continue;

        // Check for exact match or very similar
        if (plant.scientificName.toLowerCase() == scientificName.toLowerCase()) {
          duplicates.add('Duplicata exata: ${plant.scientificName} (${_formatDate(plant.dateCollected)})');
        } else if (_isSimilar(plant.scientificName, scientificName)) {
          duplicates.add('Similar: ${plant.scientificName} (${_formatDate(plant.dateCollected)})');
        }
      }

      return duplicates;
    } catch (e) {
      return [];
    }
  }

  /// Parses scientific name into genus and species
  Map<String, String?> parseScientificName(String scientificName) {
    final parts = scientificName.trim().split(' ');
    if (parts.isEmpty) {
      return {'genus': null, 'species': null};
    }

    return {
      'genus': parts.first,
      'species': parts.length > 1 ? parts[1] : null,
    };
  }

  /// Gets all unique families from existing records
  /// Uses Isar distinctBy query for efficiency
  Future<List<String>> getExistingFamilies() async {
    try {
      return await _plantRepo.getDistinctFamilies();
    } catch (e) {
      return [];
    }
  }

  /// Gets all unique genera from existing records
  /// Uses Isar distinctBy query for efficiency
  Future<List<String>> getExistingGenera() async {
    try {
      return await _plantRepo.getDistinctGenera();
    } catch (e) {
      return [];
    }
  }

  // Helper methods
  bool _isSimilar(String name1, String name2) {
    final n1 = name1.toLowerCase();
    final n2 = name2.toLowerCase();
    
    // Check if they share the same genus
    final g1 = n1.split(' ').first;
    final g2 = n2.split(' ').first;
    
    return g1 == g2;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

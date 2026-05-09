import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/theme/folium_theme.dart';
import '../../../models/plant_record.dart';
import '../../../models/plant_category.dart';
import '../../../shared/widgets/modern/modern_plant_card.dart';
import '../../../shared/widgets/modern/modern_app_bar.dart';
import '../../../shared/widgets/modern/glass_app_bar.dart';
import '../../plant_detail/screens/plant_detail_screen.dart';
import '../../../l10n/app_localizations.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  List<PlantRecord> _searchResults = [];
  bool _isSearching = false;
  bool _showFilters = false;
  
  // Search mode: 'name' or 'identifier'
  String _searchMode = 'name';
  
  // Filter options
  PlantCategory? _selectedCategory;
  bool? _isDraft;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    
    if (query.isEmpty && _selectedCategory == null && _startDate == null) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final plantRepo = ref.read(plantRepositoryProvider);
      List<PlantRecord> results = [];

      // Search based on mode
      if (query.isNotEmpty) {
        if (_searchMode == 'identifier') {
          // Identifier search
          results = await plantRepo.searchByIdentifier(
            query,
            limit: 100,
          );
        } else {
          // Text search (name)
          results = await plantRepo.fullTextSearch(
            query,
            limit: 100,
          );
        }
      } else {
        results = await plantRepo.getPaginated(limit: 100);
      }

      // Apply filters
      if (_selectedCategory != null) {
        results = results.where((p) => p.category == _selectedCategory).toList();
      }

      if (_isDraft != null) {
        results = results.where((p) => p.isDraft == _isDraft).toList();
      }

      if (_startDate != null) {
        results = results.where((p) => p.dateCollected.isAfter(_startDate!)).toList();
      }

      if (_endDate != null) {
        results = results.where((p) => p.dateCollected.isBefore(_endDate!)).toList();
      }

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorSearchMsg(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _isDraft = null;
      _startDate = null;
      _endDate = null;
    });
    _performSearch();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate 
          ? (_startDate ?? DateTime.now()) 
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _performSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: GlassAppBarFrosted(
        title: l10n.search,
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Top spacing for glass app bar
          const SizedBox(height: 80),
          
          // Search Bar
          ModernSearchBar(
            hintText: _searchMode == 'identifier' 
                ? l10n.searchByIdentifierHint
                : l10n.searchPlantsHint,
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
              if (value.length >= 2 || value.isEmpty) {
                _performSearch();
              }
            },
            onClear: () {
              _searchController.clear();
              _performSearch();
            },
            actions: [
              IconButton(
                icon: Icon(
                  _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                  color: _showFilters ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
              ),
            ],
          ),
          
          // Search Mode Selector with animated chips
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FoliumTheme.space16,
              vertical: FoliumTheme.space8,
            ),
            child: Row(
              children: [
                Text(
                  l10n.searchByLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: FoliumTheme.space12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: ChoiceChip(
                    label: const Text('Nome'),
                    selected: _searchMode == 'name',
                    selectedColor: colorScheme.primaryContainer,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _searchMode = 'name';
                          _searchController.clear();
                        });
                        _performSearch();
                      }
                    },
                  ),
                ),
                const SizedBox(width: FoliumTheme.space8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: ChoiceChip(
                    label: const Text('Identificador'),
                    selected: _searchMode == 'identifier',
                    selectedColor: colorScheme.primaryContainer,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _searchMode = 'identifier';
                          _searchController.clear();
                        });
                        _performSearch();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // Filters Section
          if (_showFilters)
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Filtros',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear_all),
                        label: Text(l10n.clearFilters),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Category Filter
                  const Text('Categoria', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Todas'),
                        selected: _selectedCategory == null,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = null;
                          });
                          _performSearch();
                        },
                      ),
                      ...PlantCategory.values.map((category) {
                        return FilterChip(
                          label: Text(category.name.toUpperCase()),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                            _performSearch();
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status Filter
                  const Text('Status', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Todos'),
                        selected: _isDraft == null,
                        onSelected: (selected) {
                          setState(() {
                            _isDraft = null;
                          });
                          _performSearch();
                        },
                      ),
                      FilterChip(
                        label: const Text('Completos'),
                        selected: _isDraft == false,
                        onSelected: (selected) {
                          setState(() {
                            _isDraft = selected ? false : null;
                          });
                          _performSearch();
                        },
                      ),
                      FilterChip(
                        label: const Text('Rascunhos'),
                        selected: _isDraft == true,
                        onSelected: (selected) {
                          setState(() {
                            _isDraft = selected ? true : null;
                          });
                          _performSearch();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Date Range Filter
                  const Text('Período', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectDate(context, true),
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            _startDate != null
                                ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                : 'Data inicial',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('até'),
                      ),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectDate(context, false),
                          icon: const Icon(Icons.event, size: 16),
                          label: Text(
                            _endDate != null
                                ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                : 'Data final',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Results
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchController.text.isEmpty
                                  ? Icons.search
                                  : Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'Digite para buscar plantas'
                                  : _searchController.text.length < 2
                                      ? 'Digite pelo menos 2 caracteres para buscar'
                                      : 'Nenhuma planta encontrada',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (_searchController.text.isNotEmpty) ...[
                              const SizedBox(height: FoliumTheme.space16),
                              ElevatedButton(
                                onPressed: _clearFilters,
                                child: Text(l10n.clearFilters),
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          final plant = _searchResults[index];
                          return ModernPlantCard(
                            plant: plant,
                            compact: true,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PlantDetailScreen(plant: plant),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

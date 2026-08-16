import 'package:flutter/material.dart';
import 'package:flutter_app/data/repository/mock_property_repository.dart';
import 'package:flutter_app/data/repository/property_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/domain/models/property/property_model.dart';
import 'package:flutter_app/core/services/property_filter.dart';
import 'package:flutter_app/core/theme/app_theme.dart';
import 'package:flutter_app/presentation/widgets/property_card.dart';
import 'package:flutter_app/presentation/widgets/property_chip_type.dart';
import 'package:flutter_app/presentation/widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.propertyRepository = const MockPropertyRepository(),
  });

  final PropertyRepository propertyRepository;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  PropertyType? _selectedType;

  bool _isLoading = true;
  List<Property> _properties = [];

  bool get _hasActiveSearch => _searchQuery.isNotEmpty || _selectedType != null;

  List<Property> get _results {
    if (!_hasActiveSearch) return const [];
    return PropertyFilter.apply(
      _properties,
      query: _searchQuery,
      type: _selectedType,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final properties = await widget.propertyRepository.getAll();
    if (!mounted) return;
    setState(() {
      _properties = properties;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                // Barre de recherche
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: CustomSearchBar(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onFilterTap: () => _openFilterBottomSheet(context),
                  ),
                ),

                // Filtres par type
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTypeFilters(),
                ),

                const SizedBox(height: 14),

                // Compteur de résultats
                if (!_isLoading && _hasActiveSearch && _results.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Résultats',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_results.length} résultat(s)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.lightSecondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Contenu principal
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : !_hasActiveSearch
                      ? _buildInitialState(theme, isDark)
                      : _results.isEmpty
                      ? _buildNoResultsState(theme, isDark)
                      : _buildResultsList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Résultats filtrés, en liste sur mobile et en grille sur tablette/desktop
  Widget _buildResultsList() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;
        if (constraints.maxWidth >= 900) {
          columns = 3;
        } else if (constraints.maxWidth >= 600) {
          columns = 2;
        }

        if (columns == 1) {
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemCount: _results.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final property = _results[index];
              return PropertyCard(
                property: property,
                onTap: () {
                  context.push(
                    '/property-detail/${property.id}',
                    extra: property,
                  );
                },
              );
            },
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: _results.length,
          itemBuilder: (context, index) {
            final property = _results[index];
            return PropertyCard(
              property: property,
              onTap: () {
                context.push(
                  '/property-detail/${property.id}',
                  extra: property,
                );
              },
            );
          },
        );
      },
    );
  }

  // Écran affiché avant toute recherche
  Widget _buildInitialState(ThemeData theme, bool isDark) {
    final secondaryColor = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              size: 56,
              color: secondaryColor.withValues(alpha: .5),
            ),
            const SizedBox(height: 16),
            Text(
              'Trouvez votre prochain chez-vous',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Recherchez par ville, quartier ou nom du bien, ou filtrez directement par type de logement.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Écran affiché quand la recherche ne retourne aucun résultat
  Widget _buildNoResultsState(ThemeData theme, bool isDark) {
    final secondaryColor = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              'Aucun logement ne correspond à votre recherche',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedType = null;
                });
              },
              child: const Text('Réinitialiser la recherche'),
            ),
          ],
        ),
      ),
    );
  }

  // Chips horizontaux pour filtrer par type de logement
  Widget _buildTypeFilters() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAllSelected = _selectedType == null;
    final unselectedText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.primaryDark;

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              avatar: Icon(
                Icons.grid_view_rounded,
                size: 16,
                color: isAllSelected
                    ? Colors.white
                    : unselectedText.withValues(alpha: .7),
              ),
              label: const Text('Tous'),
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: isAllSelected ? Colors.white : unselectedText,
              ),
              selected: isAllSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedType = null;
                  });
                }
              },
              showCheckmark: false,
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? Colors.white10 : AppColors.lightSurface,
              shape: const StadiumBorder(),
              side: const BorderSide(color: Colors.transparent, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              visualDensity: VisualDensity.compact,
              elevation: 0,
              pressElevation: 0,
            ),
          ),
          ...PropertyType.values.map((type) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: PropertyTypeChip(
                value: type,
                selected: _selectedType == type,
                onSelected: (selectedType) {
                  setState(() {
                    _selectedType = _selectedType == selectedType
                        ? null
                        : selectedType;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // BottomSheet de filtre — permet de choisir un type de logement
  void _openFilterBottomSheet(BuildContext context) {
    PropertyType? tempSelectedType = _selectedType;
    final List<PropertyType?> propertyTypes = [null, ...PropertyType.values];

    showModalBottomSheet<({bool applied, PropertyType? type})>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Filtrer par type',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<PropertyType?>(
                    initialValue: tempSelectedType,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    items: propertyTypes.map((PropertyType? type) {
                      return DropdownMenuItem<PropertyType?>(
                        value: type,
                        child: Text(
                          type == null
                              ? 'Tous'
                              : type.toString().split('.').last,
                        ),
                      );
                    }).toList(),
                    onChanged: (PropertyType? newValue) {
                      setModalState(() {
                        tempSelectedType = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            setModalState(() {
                              tempSelectedType = null;
                            });
                          },
                          child: const Text('Réinitialiser'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pop(context, (
                              applied: true,
                              type: tempSelectedType,
                            ));
                          },
                          child: const Text(
                            'Appliquer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null && result.applied) {
        setState(() {
          _selectedType = result.type;
        });
      }
    });
  }
}

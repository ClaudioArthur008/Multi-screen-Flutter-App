import 'package:flutter/material.dart';
import 'package:flutter_app/data/repository/mock_property_repository.dart';
import 'package:flutter_app/data/repository/mock_user_repository.dart';
import 'package:flutter_app/data/repository/property_repository.dart';
import 'package:flutter_app/data/repository/user_repository.dart';
import 'package:flutter_app/core/services/property_filter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/domain/models/property/property_model.dart';
import 'package:flutter_app/domain/models/user/user_model.dart';
import 'package:flutter_app/core/theme/app_theme.dart';
import 'package:flutter_app/presentation/widgets/featured_caroussel.dart';
import 'package:flutter_app/presentation/widgets/header.dart';
import 'package:flutter_app/presentation/widgets/property_card.dart';
import 'package:flutter_app/presentation/widgets/property_chip_type.dart';
import 'package:flutter_app/presentation/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.propertyRepository = const MockPropertyRepository(),
    this.userRepository = const MockUserRepository(),
  });

  final PropertyRepository propertyRepository;
  final UserRepository userRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  PropertyType? _selectedType;

  bool _isLoading = true;
  List<Property> _properties = [];
  List<Property> _featuredProperties = [];
  User? _currentUser;

  List<Property> get _filteredProperties => PropertyFilter.apply(
    _properties,
    query: _searchQuery,
    type: _selectedType,
  );

  bool get _isBrowsing => _searchQuery.isEmpty && _selectedType == null;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final properties = await widget.propertyRepository.getAll();
    final featured = await widget.propertyRepository.getFeatured();
    final user = await widget.userRepository.getCurrentUser();

    if (!mounted) return;
    setState(() {
      _properties = properties;
      _featuredProperties = featured;
      _currentUser = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  CustomHeader(
                    user: _currentUser!,
                    onNotificationTap: () {
                      // Action notifications
                    },
                  ),

                  const SizedBox(height: 24),

                  // Accroche
                  _buildHeadline(theme, isDark),

                  const SizedBox(height: 22),

                  // Barre de recherche
                  CustomSearchBar(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onFilterTap: () => _openFilterBottomSheet(context),
                  ),

                  const SizedBox(height: 18),

                  _buildTypeFilters(),

                  const SizedBox(height: 26),

                  // Carrousel
                  if (_isBrowsing && _featuredProperties.isNotEmpty) ...[
                    FeaturedCarousel(
                      properties: _featuredProperties,
                      onTap: (property) {
                        context.push(
                          '/property-detail/${property.id}',
                          extra: property,
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                  ],

                  // Titre section résultats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Suggestions',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_filteredProperties.length} résultat(s)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.lightSecondaryText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _filteredProperties.isEmpty
                      ? _buildEmptyState(theme, isDark)
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            // Détermination du nombre de colonnes
                            int columns = 1;
                            if (constraints.maxWidth >= 900) {
                              columns = 3; // Desktop / Grande tablette paysage
                            } else if (constraints.maxWidth >= 600) {
                              columns = 2; // Tablette portrait
                            }

                            // Sur mobile
                            if (columns == 1) {
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _filteredProperties.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final property = _filteredProperties[index];
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

                            // Sur tablette
                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.85,
                                  ),
                              itemCount: _filteredProperties.length,
                              itemBuilder: (context, index) {
                                final property = _filteredProperties[index];
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
                        ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeadline(ThemeData theme, bool isDark) {
    final baseStyle = theme.textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.bold,
      height: 1.15,
      letterSpacing: -0.5,
      color: isDark
          ? AppColors.darkSecondaryText
          : AppColors.lightSecondaryText,
    );

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: 'Rechercher,\n'),
          TextSpan(
            text: 'Trouver,\n',
            style: baseStyle?.copyWith(
              color: isDark ? AppColors.lightSurface : AppColors.primaryDark,
            ),
          ),
          TextSpan(
            text: 'Réserver.',
            style: baseStyle?.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // BottomSheet pour le filtrage
  void _openFilterBottomSheet(BuildContext context) {
    RangeValues currentRangeValues = const RangeValues(100000, 2000000);
    PropertyType? selectedType;
    bool isColocation = false;

    final List<PropertyType?> propertyTypes = [null, ...PropertyType.values];

    showModalBottomSheet(
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
                    'Filtres de recherche',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tranche de prix (RangeSlider)
                  Text(
                    'Tranche de prix (Ar)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: currentRangeValues,
                    min: 0,
                    max: 5000000,
                    divisions: 50,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.primary.withValues(alpha: 0.2),
                    labels: RangeLabels(
                      '${currentRangeValues.start.round()} Ar',
                      '${currentRangeValues.end.round()} Ar',
                    ),
                    onChanged: (RangeValues values) {
                      setModalState(() {
                        currentRangeValues = values;
                      });
                    },
                  ),
                  // Affichage des valeurs Min et Max sous le slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${currentRangeValues.start.round()} Ar',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${currentRangeValues.end.round()} Ar',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  //  Type de logement (Dropdown)
                  Text(
                    'Type de logement',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<PropertyType?>(
                    initialValue: selectedType,
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
                        borderSide: BorderSide(
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
                        selectedType = newValue;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Colocation acceptée',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Afficher uniquement les biens ouverts à la colocation',
                      style: TextStyle(fontSize: 12),
                    ),
                    activeThumbColor: AppColors.primary,
                    value: isColocation,
                    onChanged: (bool value) {
                      setModalState(() {
                        isColocation = value;
                      });
                    },
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
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
                        // Fermer le BottomSheet en appliquant les filtres
                        Navigator.pop(context);
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
            );
          },
        );
      },
    );
  }

  // Widget générant la liste horizontale des PropertyTypeChips
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
          // Option 'Tous'
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
              side: BorderSide(color: Colors.transparent, width: 1),
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
                    // Si on reclique sur le type actif, on réinitialise à Tous (null)
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

  // Affichage en cas d'aucun résultat trouvé
  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'Aucun logement ne correspond à votre recherche',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/property/property_model.dart';
import 'package:flutter_app/theme/app_theme.dart';
import 'package:flutter_app/widgets/featured_caroussel.dart';
import 'package:flutter_app/widgets/header.dart';
import 'package:flutter_app/widgets/property_card.dart';
import 'package:flutter_app/widgets/property_chip_type.dart';
import 'package:flutter_app/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  PropertyType? _selectedType;

  List<Property> get _filteredProperties {
    return MockData.properties.where((property) {
      final query = _searchQuery.toLowerCase();
      final matchesQuery =
          _searchQuery.isEmpty ||
          property.designation.toLowerCase().contains(query) ||
          property.location.toLowerCase().contains(query);

      final matchesType =
          _selectedType == null || property.type == _selectedType;

      return matchesQuery && matchesType;
    }).toList();
  }

  // Les biens mis en avant dans le carrousel (les 5 premiers, par ex.)
  List<Property> get _featuredProperties =>
      MockData.properties.take(5).toList();

  // Le carrousel + le tag "Meilleure offre" ne sont pertinents
  // que tant qu'aucune recherche/filtre n'est active.
  bool get _isBrowsing => _searchQuery.isEmpty && _selectedType == null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              CustomHeader(
                user: MockData.currentUser,
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
                    // Navigation vers les détails
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

              // Liste de logements filtrés
              _filteredProperties.isEmpty
                  ? _buildEmptyState(theme, isDark)
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _filteredProperties.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return PropertyCard(
                          property: _filteredProperties[index],
                          onTap: () {
                            // Navigation vers les détails
                          },
                        );
                      },
                    ),

              const SizedBox(height: 12),
            ],
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
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permet de dépasser la moitié de l'écran si besoin
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                20, // Gestion du clavier
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // S'adapte au contenu
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicateur visuel de glissement (Handle bar)
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
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Contenu de votre formulaire/filtre
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Appliquer'),
              ),
            ],
          ),
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

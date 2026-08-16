import 'package:flutter/material.dart';
import 'package:flutter_app/domain/models/property/property_model.dart';
import 'package:flutter_app/presentation/screens/booking/booking_screen.dart';
import 'package:flutter_app/presentation/screens/home/home_screen.dart';
import 'package:flutter_app/presentation/screens/profile/profile_screen.dart';
import 'package:flutter_app/presentation/screens/property_details/property_details.dart';
import 'package:flutter_app/presentation/screens/search/search_screen.dart';
import 'package:flutter_app/presentation/widgets/add_property_sheet.dart';
import 'package:flutter_app/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder:
          (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) {
            return NavBar(navigationShell: navigationShell);
          },
      branches: <StatefulShellBranch>[
        // Accueil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Recherche
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        // Réservations
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/booking',
              builder: (context, state) => const BookingScreen(),
            ),
          ],
        ),
        // Profil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/property-detail/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final String propertyId = state.pathParameters['id']!;
        final property = state.extra as Property?;

        return PropertyDetailsScreen(id: propertyId, property: property);
      },
    ),
  ],
);

class NavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavBar({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  // Utilisé uniquement pour la vue Mobile
  Widget _buildMobileNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = navigationShell.currentIndex == index;
    final color = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText);

    return Expanded(
      child: InkWell(
        onTap: () => _onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BottomSheet pour l'ajout de logement
  void _openAddBottomSheet(
    BuildContext context, {
    void Function(Map<String, dynamic> logement)? onAdd,
  }) {
    final TextEditingController designationController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController capacityController = TextEditingController();
    final TextEditingController availableSpotsController =
        TextEditingController();

    PropertyType selectedType = PropertyType.apartment;
    RentalMode selectedMode = RentalMode.individual;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
            final isDark = theme.brightness == Brightness.dark;

            return Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //  Header
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              tooltip: 'Retour',
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: colorScheme.onSurface,
                              ),
                            ),

                            Expanded(
                              child: Text(
                                'Ajouter un logement',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),

                            // Espace permettant de garder le titre centré
                            const SizedBox(width: 48),
                          ],
                        ),

                        const SizedBox(height: 20),

                        //  Titre
                        TextField(
                          controller: designationController,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: 'Titre du logement',
                            labelStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            prefixIcon: Icon(
                              Icons.home_outlined,
                              color: colorScheme.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        //  Description
                        TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: 'Description du logement',
                            labelStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 42),
                              child: Icon(
                                Icons.description_outlined,
                                color: colorScheme.primary,
                              ),
                            ),
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        //  Prix
                        TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: 'Prix (Ar)',
                            labelStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            prefixIcon: Icon(
                              Icons.payments_outlined,
                              color: colorScheme.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Localisation
                        TextField(
                          controller: locationController,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: 'Localisation',
                            labelStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                              color: colorScheme.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Image
                        TextField(
                          controller: imageUrlController,
                          keyboardType: TextInputType.url,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: "URL de l'image",
                            labelStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            prefixIcon: Icon(
                              Icons.image_outlined,
                              color: colorScheme.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Capacité
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: capacityController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: colorScheme.onSurface),
                                decoration: InputDecoration(
                                  labelText: 'Capacité',
                                  labelStyle: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.people_outline,
                                    color: colorScheme.primary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: TextField(
                                controller: availableSpotsController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: colorScheme.onSurface),
                                decoration: InputDecoration(
                                  labelText: 'Places disponibles',
                                  labelStyle: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.event_seat_outlined,
                                    color: colorScheme.primary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        //  Type de Logement
                        Text(
                          'Type de logement',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),

                        const SizedBox(height: 10),

                        DropdownButtonFormField<PropertyType>(
                          initialValue: selectedType,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          style: TextStyle(color: colorScheme.onSurface),
                          dropdownColor: colorScheme.surface,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.home_work_outlined,
                              color: colorScheme.primary,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          items: PropertyType.values.map((PropertyType type) {
                            return DropdownMenuItem<PropertyType>(
                              value: type,
                              child: Text(type.toString().split('.').last),
                            );
                          }).toList(),
                          onChanged: (PropertyType? newValue) {
                            if (newValue == null) return;

                            setModalState(() {
                              selectedType = newValue;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Mode de Location
                        Text(
                          'Mode de location',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),

                        const SizedBox(height: 10),

                        DropdownButtonFormField<RentalMode>(
                          initialValue: selectedMode,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          style: TextStyle(color: colorScheme.onSurface),
                          dropdownColor: colorScheme.surface,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.key_outlined,
                              color: colorScheme.primary,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          items: RentalMode.values.map((RentalMode mode) {
                            return DropdownMenuItem<RentalMode>(
                              value: mode,
                              child: Text(mode.toString().split('.').last),
                            );
                          }).toList(),
                          onChanged: (RentalMode? newValue) {
                            if (newValue == null) return;

                            setModalState(() {
                              selectedMode = newValue;
                            });
                          },
                        ),

                        const SizedBox(height: 32),

                        //  Bouton d'actions
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            label: const Text('Enregistrer le logement'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              elevation: isDark ? 0 : 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              final String designation = designationController
                                  .text
                                  .trim();

                              final String description = descriptionController
                                  .text
                                  .trim();

                              final double price =
                                  double.tryParse(priceController.text) ?? 0.0;

                              final String location = locationController.text
                                  .trim();

                              final String imageUrl = imageUrlController.text
                                  .trim();

                              final int? capacity = int.tryParse(
                                capacityController.text,
                              );

                              final int? availableSpots = int.tryParse(
                                availableSpotsController.text,
                              );

                              if (designation.isEmpty || price <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: colorScheme.error,
                                    content: Text(
                                      'Veuillez renseigner au moins un titre et un prix valide.',
                                      style: TextStyle(
                                        color: colorScheme.onError,
                                      ),
                                    ),
                                  ),
                                );

                                return;
                              }

                              onAdd?.call({
                                'designation': designation,
                                'description': description,
                                'price': price,
                                'location': location,
                                'imageUrl': imageUrl,
                                'capacity': capacity,
                                'availableSpots': availableSpots,
                                'type': selectedType,
                                'mode': selectedMode,
                              });

                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      designationController.dispose();
      descriptionController.dispose();
      priceController.dispose();
      locationController.dispose();
      imageUrlController.dispose();
      capacityController.dispose();
      availableSpotsController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // LayoutBuilder vérifie l'espace disponible en temps réel
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Scaffold(
            body: Row(
              children: [
                // Navigation latérale
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _onTap,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: isDark
                      ? theme.colorScheme.surface
                      : AppColors.lightSurface,
                  selectedIconTheme: const IconThemeData(
                    color: AppColors.primary,
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedIconTheme: IconThemeData(
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                  unselectedLabelTextStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                    fontSize: 12,
                  ),

                  leading: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: AppColors.primary,
                      onPressed: () => AddPropertySheet.show(
                        context,
                        onAdd: (logement) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${logement['designation']} ajouté',
                              ),
                            ),
                          );
                        },
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.explore_outlined),
                      selectedIcon: Icon(Icons.explore_rounded),
                      label: Text('Explorer'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.search_rounded),
                      selectedIcon: Icon(Icons.search_rounded),
                      label: Text('Recherche'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_today_outlined),
                      selectedIcon: Icon(Icons.calendar_today_rounded),
                      label: Text('Réservations'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('Profil'),
                    ),
                  ],
                ),
                // Séparateur vertical subtil
                VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),

                Expanded(child: navigationShell),
              ],
            ),
          );
        }

        return Scaffold(
          body: navigationShell,

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SizedBox(
            height: 56,
            width: 56,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              elevation: 3,
              backgroundColor: AppColors.primary,
              onPressed: () {
                // Affichage de la modal d'ajout de logement
                _openAddBottomSheet(context);
              },
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: isDark ? theme.colorScheme.surface : AppColors.lightSurface,
            surfaceTintColor: Colors.transparent,
            elevation: 10,
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMobileNavItem(
                    index: 0,
                    icon: Icons.explore_outlined,
                    activeIcon: Icons.explore_rounded,
                    label: 'Explorer',
                    isDark: isDark,
                  ),
                  _buildMobileNavItem(
                    index: 1,
                    icon: Icons.search_rounded,
                    activeIcon: Icons.search_rounded,
                    label: 'Recherche',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 48),
                  _buildMobileNavItem(
                    index: 2,
                    icon: Icons.calendar_today_outlined,
                    activeIcon: Icons.calendar_today_rounded,
                    label: 'Réservations',
                    isDark: isDark,
                  ),
                  _buildMobileNavItem(
                    index: 3,
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: 'Profil',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

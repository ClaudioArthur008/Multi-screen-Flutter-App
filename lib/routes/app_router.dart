import 'package:flutter/material.dart';
import 'package:flutter_app/models/property/property_model.dart';
import 'package:flutter_app/screens/booking/booking_screen.dart';
import 'package:flutter_app/screens/home/home_screen.dart';
import 'package:flutter_app/screens/profile/profile_screen.dart';
import 'package:flutter_app/screens/property_details/property_details.dart';
import 'package:flutter_app/screens/search/search_screen.dart';
import 'package:flutter_app/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
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

  Widget _buildNavItem({
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,

      // Bouton central d'ajout
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 56,
        width: 56,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          elevation: 3,
          backgroundColor: AppColors.primary,
          onPressed: () {
            // Affichage de la modal d'ajout de logement
          },
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),

      // Barre de navigation
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
              // Onglet 0
              _buildNavItem(
                index: 0,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore_rounded,
                label: 'Explorer',
                isDark: isDark,
              ),
              // Onglet 1
              _buildNavItem(
                index: 1,
                icon: Icons.search_rounded,
                activeIcon: Icons.search_rounded,
                label: 'Recherche',
                isDark: isDark,
              ),

              // Espace réservé pour le FloatingActionButton central
              const SizedBox(width: 48),

              // Onglet 2
              _buildNavItem(
                index: 2,
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today_rounded,
                label: 'Réservations',
                isDark: isDark,
              ),
              // Onglet 3
              _buildNavItem(
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
  }
}

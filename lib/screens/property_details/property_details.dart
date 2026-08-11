import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/property/property_model.dart';
import 'package:flutter_app/theme/app_theme.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String? id;
  final Property? property;

  const PropertyDetailsScreen({super.key, this.id, this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool _isFavorite = false;

  Property? get _currentProperty {
    if (widget.property != null) return widget.property;

    if (widget.id != null) {
      try {
        return MockData.properties.firstWhere(
          (property) => property.id == widget.id,
        );
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final property = _currentProperty;

    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: const Center(child: Text('Logement introuvable.')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header avec image immersive
          SliverAppBar(
            expandedHeight: 320.0,
            pinned: true,
            backgroundColor: isDark ? theme.colorScheme.surface : Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: isDark ? Colors.black54 : Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  color: isDark ? Colors.white : Colors.black87,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: isDark ? Colors.black54 : Colors.white70,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      size: 20,
                      color: _isFavorite
                          ? Colors.red
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                property.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.home_rounded,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // Contenu principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type de logement (Badge)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          property.type.icon,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          property.type.label,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Titre
                  Text(
                    property.designation,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Localisation
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        property.location,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.lightSecondaryText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Divider(),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                  ),

                  const SizedBox(
                    height: 100,
                  ), // Espace pour la barre inférieure
                ],
              ),
            ),
          ),
        ],
      ),

      // Barre fixe de réservation en bas
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Prix
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prix par mois',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${property.price} Ar',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Bouton Réserver
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // Action de réservation
                },
                child: const Text(
                  'Réserver',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

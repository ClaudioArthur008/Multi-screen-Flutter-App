import 'package:flutter/material.dart';
import 'package:flutter_app/models/property/property_model.dart';

class AddPropertySheet extends StatefulWidget {
  final void Function(Map<String, dynamic> logement)? onAdd;

  const AddPropertySheet({super.key, this.onAdd});
  static Future<void> show(
    BuildContext context, {
    void Function(Map<String, dynamic> logement)? onAdd,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPropertySheet(onAdd: onAdd),
    );
  }

  @override
  State<AddPropertySheet> createState() => _AddPropertySheetState();
}

class _AddPropertySheetState extends State<AddPropertySheet> {
  final _formKey = GlobalKey<FormState>();

  final _designationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _capacityController = TextEditingController();
  final _availableSpotsController = TextEditingController();

  PropertyType _selectedType = PropertyType.apartment;
  RentalMode _selectedMode = RentalMode.individual;

  @override
  void dispose() {
    _designationController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _capacityController.dispose();
    _availableSpotsController.dispose();
    super.dispose();
  }

  String? _validateDesignation(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Le titre est obligatoire';
    if (trimmed.length < 3) {
      return 'Le titre doit contenir au moins 3 caractères';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Le prix est obligatoire';
    final price = double.tryParse(trimmed.replaceAll(',', '.'));
    if (price == null) return 'Veuillez saisir un nombre valide';
    if (price <= 0) return 'Le prix doit être supérieur à 0';
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La localisation est obligatoire';
    }
    return null;
  }

  String? _validateImageUrl(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null; // champ optionnel
    final uri = Uri.tryParse(trimmed);
    final isValid =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    if (!isValid) return 'Veuillez saisir une URL valide (http/https)';
    return null;
  }

  String? _validateCapacity(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null; // champ optionnel
    final capacity = int.tryParse(trimmed);
    if (capacity == null || capacity <= 0) {
      return 'Doit être un nombre entier positif';
    }
    return null;
  }

  String? _validateAvailableSpots(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null; // champ optionnel
    final spots = int.tryParse(trimmed);
    if (spots == null || spots < 0) {
      return 'Doit être un nombre entier positif ou nul';
    }
    final capacityText = _capacityController.text.trim();
    if (capacityText.isNotEmpty) {
      final capacity = int.tryParse(capacityText);
      if (capacity != null && spots > capacity) {
        return 'Ne peut pas dépasser la capacité ($capacity)';
      }
    }
    return null;
  }

  void _handleSave() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final designation = _designationController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.parse(
      _priceController.text.trim().replaceAll(',', '.'),
    );
    final location = _locationController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final capacity = int.tryParse(_capacityController.text.trim());
    final availableSpots = int.tryParse(_availableSpotsController.text.trim());

    widget.onAdd?.call({
      'designation': designation,
      'description': description,
      'price': price,
      'location': location,
      'imageUrl': imageUrl,
      'capacity': capacity,
      'availableSpots': availableSpots,
      'type': _selectedType,
      'mode': _selectedMode,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
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
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const Key('add_property_designation_field'),
                    controller: _designationController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Titre du logement',
                      prefixIcon: Icon(Icons.home_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateDesignation,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('add_property_description_field'),
                    controller: _descriptionController,
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Description du logement',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('add_property_price_field'),
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Prix (Ar)',
                      prefixIcon: Icon(Icons.payments_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validatePrice,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('add_property_location_field'),
                    controller: _locationController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Localisation',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateLocation,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('add_property_image_field'),
                    controller: _imageUrlController,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "URL de l'image",
                      prefixIcon: Icon(Icons.image_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateImageUrl,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: const Key('add_property_capacity_field'),
                          controller: _capacityController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Capacité',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateCapacity,
                          // La capacité influence la validité du champ
                          // "places disponibles" : on redéclenche sa validation
                          // à chaque changement pour garder les deux champs cohérents.
                          onChanged: (_) => _formKey.currentState?.validate(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          key: const Key('add_property_spots_field'),
                          controller: _availableSpotsController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Places disponibles',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateAvailableSpots,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Type de logement',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<PropertyType>(
                    key: const Key('add_property_type_dropdown'),
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: PropertyType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedType = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Mode de location',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<RentalMode>(
                    key: const Key('add_property_mode_dropdown'),
                    initialValue: _selectedMode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: RentalMode.values.map((mode) {
                      return DropdownMenuItem(
                        value: mode,
                        child: Text(mode.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedMode = value);
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: const Key('add_property_save_button'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _handleSave,
                      child: const Text('Enregistrer le logement'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

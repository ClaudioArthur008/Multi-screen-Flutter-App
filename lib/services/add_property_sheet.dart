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

  void _handleSave() {
    final designation = _designationController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final location = _locationController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final capacity = int.tryParse(_capacityController.text);
    final availableSpots = int.tryParse(_availableSpotsController.text);

    if (designation.isEmpty || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            'Veuillez renseigner au moins un titre et un prix valide.',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
        ),
      );
      return;
    }

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
                TextField(
                  key: const Key('add_property_designation_field'),
                  controller: _designationController,
                  decoration: const InputDecoration(
                    labelText: 'Titre du logement',
                    prefixIcon: Icon(Icons.home_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('add_property_description_field'),
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description du logement',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('add_property_price_field'),
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Prix (Ar)',
                    prefixIcon: Icon(Icons.payments_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('add_property_location_field'),
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Localisation',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('add_property_image_field'),
                  controller: _imageUrlController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: "URL de l'image",
                    prefixIcon: Icon(Icons.image_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('add_property_capacity_field'),
                        controller: _capacityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Capacité',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        key: const Key('add_property_spots_field'),
                        controller: _availableSpotsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Places disponibles',
                          border: OutlineInputBorder(),
                        ),
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
    );
  }
}

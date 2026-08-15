import 'package:flutter_app/models/property/property_model.dart';

class PropertyFilter {
  static List<Property> apply(
    List<Property> properties, {
    String query = '',
    PropertyType? type,
  }) {
    final q = query.toLowerCase();
    return properties.where((p) {
      final matchesQuery =
          q.isEmpty ||
          p.designation.toLowerCase().contains(q) ||
          p.location.toLowerCase().contains(q);
      final matchesType = type == null || p.type == type;
      return matchesQuery && matchesType;
    }).toList();
  }
}

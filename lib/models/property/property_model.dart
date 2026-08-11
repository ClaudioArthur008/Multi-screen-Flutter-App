import 'package:flutter/material.dart';

enum PropertyType {
  room,
  residence,
  apartment;

  // Libellé public
  String get label {
    switch (this) {
      case PropertyType.room:
        return 'Chambre';
      case PropertyType.residence:
        return 'Résidence';
      case PropertyType.apartment:
        return 'Appartement';
    }
  }

  // Icône
  IconData get icon {
    switch (this) {
      case PropertyType.room:
        return Icons.bed_rounded;
      case PropertyType.residence:
        return Icons.villa_rounded;
      case PropertyType.apartment:
        return Icons.apartment_rounded;
    }
  }
}

enum RentalMode { individual, shared }

class Property {
  final String id;
  final String designation;
  final String? description;
  final PropertyType type;
  final RentalMode mode;
  final double price;
  final double rating;
  final String location;
  final String imageUrl;
  final int? capacity;
  final int? availableSpots;

  const Property({
    required this.id,
    required this.designation,
    this.description,
    required this.type,
    this.mode = RentalMode.individual,
    required this.price,
    this.rating = 0,
    required this.location,
    required this.imageUrl,
    this.capacity = 0,
    this.availableSpots = 0,
  });
}

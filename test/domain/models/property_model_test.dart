import 'package:flutter_app/domain/models/property/property_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('PropertyType Enum Tests', () {
    test('PropertyType.room doit retourner les bonnes valeurs', () {
      expect(PropertyType.room.label, 'Chambre');
      expect(PropertyType.room.icon, Icons.bed_rounded);
    });

    test('PropertyType.residence doit retourner les bonnes valeurs', () {
      expect(PropertyType.residence.label, 'Résidence');
      expect(PropertyType.residence.icon, Icons.villa_rounded);
    });

    test('PropertyType.apartment doit retourner les bonnes valeurs', () {
      expect(PropertyType.apartment.label, 'Appartement');
      expect(PropertyType.apartment.icon, Icons.apartment_rounded);
    });
  });

  group('Property Model Tests', () {
    test('Doit créer une Property avec les valeurs par défaut correctes', () {
      const property = Property(
        id: 'prop-123',
        designation: 'Chambre Étudiant',
        type: PropertyType.room,
        price: 350.0,
        location: 'Antananarivo',
        imageUrl: 'https://example.com/image.jpg',
      );

      expect(property.id, 'prop-123');
      expect(property.designation, 'Chambre Étudiant');
      expect(property.price, 350.0);

      expect(property.mode, RentalMode.individual);
      expect(property.rating, 0.0);
      expect(property.capacity, 0);
      expect(property.availableSpots, 0);

      expect(property.description, isNull);
    });

    test('Doit créer une Property avec toutes les valeurs personnalisées', () {
      const fullProperty = Property(
        id: 'prop-456',
        designation: 'Villa de luxe',
        description: 'Une belle villa avec piscine',
        type: PropertyType.residence,
        mode: RentalMode.shared,
        price: 1500000.0,
        rating: 4.8,
        location: 'Ambatobe',
        imageUrl: 'https://example.com/villa.jpg',
        capacity: 10,
        availableSpots: 2,
      );

      expect(fullProperty.mode, RentalMode.shared);
      expect(fullProperty.rating, 4.8);
      expect(fullProperty.description, 'Une belle villa avec piscine');
      expect(fullProperty.capacity, 10);
      expect(fullProperty.availableSpots, 2);
    });
  });
}

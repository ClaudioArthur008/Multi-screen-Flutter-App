import 'package:flutter_app/services/property_filter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/property/property_model.dart';

void main() {
  final properties = [
    Property(
      id: '1',
      designation: 'Studio Centre-ville',
      location: 'Antananarivo',
      type: PropertyType.apartment,
      price: 300000,
      imageUrl: 'assets/images/campus.jfif',
    ),
    Property(
      id: '2',
      designation: 'Villa avec jardin',
      location: 'Fianarantsoa',
      type: PropertyType.residence,
      price: 800000,
      imageUrl: 'assets/images/campus.jfif',
    ),
  ];

  test('filtre par mot-clé sur le titre', () {
    final result = PropertyFilter.apply(properties, query: 'studio');
    expect(result.length, 1);
    expect(result.first.id, '1');
  });

  test('filtre par type de logement', () {
    final result = PropertyFilter.apply(
      properties,
      type: PropertyType.apartment,
    );
    expect(result.length, 1);
    expect(result.first.id, '1');
  });

  test('retourne tout si aucun filtre', () {
    expect(PropertyFilter.apply(properties).length, 2);
  });

  test('combine mot-clé et type sans résultat', () {
    final result = PropertyFilter.apply(
      properties,
      query: 'studio',
      type: PropertyType.room,
    );
    expect(result, isEmpty);
  });

  test('filtre par mot-clé sur la localisation', () {
    final result = PropertyFilter.apply(properties, query: 'fianarantsoa');
    expect(result.length, 1);
    expect(result.first.id, '2');
  });

  test('combine mot-clé et type avec résultat', () {
    final result = PropertyFilter.apply(
      properties,
      query: 'villa',
      type: PropertyType.residence,
    );
    expect(result.length, 1);
    expect(result.first.id, '2');
  });
}

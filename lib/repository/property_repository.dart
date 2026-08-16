import 'package:flutter_app/models/property/property_model.dart';

abstract class PropertyRepository {
  Future<List<Property>> getAll();
  Future<Property?> getById(String id);
  Future<List<Property>> getFeatured({int limit = 5});
}

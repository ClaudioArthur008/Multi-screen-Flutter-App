import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/repository/property_repository.dart';
import 'package:flutter_app/domain/models/property/property_model.dart';

class MockPropertyRepository implements PropertyRepository {
  const MockPropertyRepository({this.simulatedLatency = Duration.zero});

  final Duration simulatedLatency;

  Future<void> _simulateLatency() {
    if (simulatedLatency == Duration.zero) return Future.value();
    return Future.delayed(simulatedLatency);
  }

  @override
  Future<List<Property>> getAll() async {
    await _simulateLatency();
    return List.unmodifiable(MockData.properties);
  }

  @override
  Future<Property?> getById(String id) async {
    await _simulateLatency();
    for (final property in MockData.properties) {
      if (property.id == id) return property;
    }
    return null;
  }

  @override
  Future<List<Property>> getFeatured({int limit = 5}) async {
    await _simulateLatency();
    return MockData.properties.take(limit).toList();
  }
}

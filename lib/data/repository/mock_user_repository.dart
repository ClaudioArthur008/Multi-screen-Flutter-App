import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/domain/models/user/user_model.dart';
import 'package:flutter_app/data/repository/user_repository.dart';

class MockUserRepository implements UserRepository {
  const MockUserRepository();

  @override
  Future<User> getCurrentUser() async => MockData.currentUser;
}

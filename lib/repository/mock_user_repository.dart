import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/user/user_model.dart';
import 'package:flutter_app/repository/user_repository.dart';

class MockUserRepository implements UserRepository {
  const MockUserRepository();

  @override
  Future<User> getCurrentUser() async => MockData.currentUser;
}

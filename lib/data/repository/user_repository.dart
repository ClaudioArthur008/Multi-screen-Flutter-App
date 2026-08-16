import 'package:flutter_app/domain/models/user/user_model.dart';

abstract class UserRepository {
  /// Retourne l'utilisateur actuellement connecté.
  Future<User> getCurrentUser();
}

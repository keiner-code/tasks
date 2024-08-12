import 'package:tasks/domain/entities/user.dart';

abstract class AuthDatasource {
  Future<User?> create(String name, String email, String password);
  Future<User?> login(String email, String password);
  Future<void> logout();
  Future<bool> isLogin();
}

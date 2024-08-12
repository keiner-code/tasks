import 'package:tasks/domain/datasources/auth_datasource.dart';
import 'package:tasks/domain/entities/user.dart';
import 'package:tasks/infrastructure/datasources/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthDatasource {
  final AuthDatasource datasource;
  AuthRepositoryImpl({AuthDatasource? datasource})
      : datasource = datasource ?? AuthDatasourceImpl();

  @override
  Future<User?> create(String name, String email, String password) {
    return datasource.create(name, email, password);
  }

  @override
  Future<bool> isLogin() {
    return datasource.isLogin();
  }

  @override
  Future<User?> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
  Future<void> logout() {
    return datasource.logout();
  }
}

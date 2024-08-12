import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:tasks/domain/datasources/auth_datasource.dart';
import 'package:tasks/domain/entities/user.dart';

class AuthDatasourceImpl extends AuthDatasource {
  @override
  Future<User?> create(String name, String email, String password) async {
    try {
      final credential =
          await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebase.User? user = credential.user;
      if (user != null) {
        await user.updateProfile(displayName: name);
        user = firebase.FirebaseAuth.instance.currentUser;
        return User(
            displayName: user!.displayName!, email: user.email!, uid: user.uid);
      }
      return null;
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La contraseña proporcionada es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        print('La cuenta ya existe para ese correo electrónico.');
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLogin() {
    // TODO: implement isLogin
    throw UnimplementedError();
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final credential = await firebase.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      return User(
          displayName: user!.displayName!, email: user.email!, uid: user.uid);
    } on firebase.FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await firebase.FirebaseAuth.instance.signOut();
  }
}

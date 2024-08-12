import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:tasks/domain/entities/user.dart';
import 'package:tasks/infrastructure/datasources/auth_datasource_impl.dart';
import 'package:tasks/infrastructure/repositories/auth_repository_impl.dart';
import 'package:tasks/presentation/widget/inputs/email.dart';
import 'package:tasks/presentation/widget/inputs/name.dart';
import 'package:tasks/presentation/widget/inputs/password.dart';

part 'form_cubit_state.dart';

class FormCubit extends Cubit<FormCubitState> {
  FormCubit() : super(const FormCubitState());
  final repository = AuthRepositoryImpl(datasource: AuthDatasourceImpl());

  void onSubmit(String option) async {
    emit(state.copyWith(
        formStatus: FormStatus.validiting,
        name: Name.dirty(value: state.name.value),
        password: Password.dirty(value: state.password.value),
        email: Email.dirty(value: state.email.value),
        isValid: Formz.validate([state.password, state.email])));
    if (option == 'Registrarse') register();
    if (option == 'Login') login();
  }

  void register() async {
    final user = await repository.create(
        state.name.value, state.email.value, state.password.value);
    if (user != null) {
      //final newUser = User(email: user.email!);
      emit(state.copyWith(user: user));
    }
  }

  void logout() async {
    await repository.logout();
    emit(const FormCubitState());
  }

  void login() async {
    final user =
        await repository.login(state.email.value, state.password.value);
    if (user != null) {
      //final loginUser = User(email: user.email!);
      emit(state.copyWith(user: user));
    }
  }

  void isLogin(User user) {
    emit(state.copyWith(user: user));
  }

  void nameChange(String value) {
    final name = Name.dirty(value: value);
    emit(state.copyWith(
        name: name,
        isValid: Formz.validate([name, state.email, state.password])));
  }

  void emailChange(String value) {
    final email = Email.dirty(value: value);
    emit(state.copyWith(
        email: email,
        isValid: Formz.validate([
          state.name,
          email,
          state.password,
        ])));
  }

  void passwordChange(String value) {
    final password = Password.dirty(value: value);
    emit(state.copyWith(
        password: password,
        isValid: Formz.validate([state.name, state.email, password])));
  }
}

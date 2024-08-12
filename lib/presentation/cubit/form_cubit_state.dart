part of 'form_cubit.dart';

enum FormStatus { invalid, valid, validiting, posted }

class FormCubitState extends Equatable {
  final FormStatus formStatus;
  final bool isValid;
  final Name name;
  final Email email;
  final Password password;
  final User? user;

  const FormCubitState(
      {this.formStatus = FormStatus.invalid,
      this.isValid = false,
      this.name = const Name.pure(),
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.user});

  FormCubitState copyWith(
          {FormStatus? formStatus,
          bool? isValid,
          Name? name,
          Email? email,
          Password? password,
          User? user}) =>
      FormCubitState(
          formStatus: formStatus ?? this.formStatus,
          isValid: isValid ?? this.isValid,
          name: name ?? this.name,
          email: email ?? this.email,
          password: password ?? this.password,
          user: user ?? this.user);

  @override
  List<Object?> get props => [formStatus, isValid, name, email, password, user];
}

import 'package:formz/formz.dart';

enum PasswordError { empty, length }

class Password extends FormzInput<String, PasswordError> {
  const Password.pure() : super.pure('');
  const Password.dirty({String value = ''}) : super.dirty(value);

  String? get errorMessages {
    if (isValid || isPure) return null;
    if (displayError == PasswordError.empty) return "Ingrese una contraseña";
    if (displayError == PasswordError.length) return "Minimo 8 caracteres";
    return null;
  }

  @override
  PasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PasswordError.empty;
    if (value.length < 7) return PasswordError.length;
    return null;
  }
}

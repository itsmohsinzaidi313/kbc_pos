import 'package:formz/formz.dart';

enum UsernameValidationError { invalid }

class Username extends FormzInput<String, UsernameValidationError> {

  const Username.pure([String value = '']) : super.pure(value);
  const Username.dirty([String value = '']) : super.dirty(value);

  @override
  UsernameValidationError validator(String value) {
    return value.isNotEmpty ? null : UsernameValidationError.invalid;
  }
}
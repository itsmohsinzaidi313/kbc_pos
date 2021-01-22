import 'package:formz/formz.dart';

enum CoversValidationError { invalid }

class Covers extends FormzInput<String, CoversValidationError> {

  const Covers.pure([String value = '']) : super.pure(value);
  const Covers.dirty([String value = '']) : super.dirty(value);

  @override
  CoversValidationError validator(String value) {
    return null;
  }
}
import 'package:formz/formz.dart';

enum ShiftValidationError { invalid }

class Shift extends FormzInput<String, ShiftValidationError>{

  const Shift.dirty([String value = '']) : super.dirty(value);
  const Shift.pure([String value = '']) : super.pure(value);

  @override
  ShiftValidationError validator(String value) {
    return value.isNotEmpty ? null : ShiftValidationError.invalid;
  }

}
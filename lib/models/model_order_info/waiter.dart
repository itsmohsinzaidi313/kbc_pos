import 'package:formz/formz.dart';

enum WaiterValidationError { invalid }

class Waiter extends FormzInput<String, WaiterValidationError> {

  const Waiter.pure([String value = '']) : super.pure(value);
  const Waiter.dirty([String value = '']) : super.dirty(value);

  @override
  WaiterValidationError validator(String value) {
    return null;
  }
}
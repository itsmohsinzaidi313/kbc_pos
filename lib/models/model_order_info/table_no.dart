import 'package:formz/formz.dart';

enum TableNoValidationError { invalid }

class TableNo extends FormzInput<String, TableNoValidationError> {

  const TableNo.pure([String value = '']) : super.pure(value);
  const TableNo.dirty([String value = '']) : super.dirty(value);

  @override
  TableNoValidationError validator(String value) {
    return null;
  }
}
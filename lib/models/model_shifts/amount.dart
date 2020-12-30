import 'package:formz/formz.dart';

enum AmountValidationError { invalid }

class Amount extends FormzInput<String, AmountValidationError>{

  const Amount.dirty([String value = '']) : super.dirty(value);
  const Amount.pure([String value = '']) : super.pure(value);

  @override
  AmountValidationError validator(String value) {
    if(value.isNotEmpty){
      if(value.isNotEmpty && int.tryParse(value) > 0){
        return null;
      } else{
        return AmountValidationError.invalid;
      }
    }
    return AmountValidationError.invalid;
  }

}
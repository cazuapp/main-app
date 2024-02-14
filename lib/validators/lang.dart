import 'package:formz/formz.dart';

enum LangValidationError { invalid }

class Lang extends FormzInput<String, LangValidationError> {
  const Lang.pure([super.value = '']) : super.pure();
  const Lang.dirty([super.value = '']) : super.dirty();

  @override
  LangValidationError? validator(String? value) {
    if (value!.isEmpty || value.length > 2) {
      return LangValidationError.invalid;
    } else {
      return null;
    }
  }
}

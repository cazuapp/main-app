import 'package:formz/formz.dart';

import '../components/etc.dart';

enum PhoneCodeValidationError { invalid }

class PhoneCode extends FormzInput<String, PhoneCodeValidationError> {
  const PhoneCode.pure([super.value = '']) : super.pure();
  const PhoneCode.dirty([super.value = '']) : super.dirty();

  @override
  PhoneCodeValidationError? validator(String? value) {
    if (value!.isEmpty || value.length > 3 || !Etc.isNumeric(value)) {
      return PhoneCodeValidationError.invalid;
    } else {
      return null;
    }
  }
}

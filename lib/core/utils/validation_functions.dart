
import 'package:news_zen/core/localization/app_strings.dart';
import 'package:string_validator/string_validator.dart';

bool isEmptyString(String? inputString)
{
  bool isInputStringEmpty=false;
  if(inputString==null ? true : inputString.isEmpty)
  {
    isInputStringEmpty=true;
  }
  return isInputStringEmpty;
}

bool isOnlyNumeric(String inputString)
{
  final numericRegex = RegExp(r'^-?\d+(\.\d+)?$');
  if (numericRegex.hasMatch(inputString)) {
    return true;
  }
  return false;

}
String? isEmptyErrorMessage(String? inputString)
{
  return isEmptyString(inputString) ? AppStrings.errMsgRequiredField : null;
}

String? isInvalidErrorMessage(String? inputString)
{
  return !isEmptyString(inputString) && isOnlyNumeric(inputString ?? 'a')? null : AppStrings.errMsgInvalidInput;
}


String? isValidPhone(String? inputString)
{
  bool isInputStringValid=false;
  if(!isEmptyString(inputString) && isNumeric(inputString ?? 'a'))
  {
    isInputStringValid=inputString?.length==11;
    isInputStringValid=isInputStringValid && (inputString!.startsWith('0') && (inputString[1]=='1'));
  }
  return isInputStringValid ? null : AppStrings.errMsgPleaseEnterValidPhone;
}

String? isValidPassword(String? inputString)
{
  bool isInputStringValid=false;
  if(!isEmptyString(inputString))
  {
    const pattern =
        r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$';
    final regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString!);
  }

  return isInputStringValid ? null : AppStrings.errMsgPleaseEnterValidPassword;
}

String? isValidEmail(String? inputString) {
  bool isInputStringValid = false;
  if (!isEmptyString(inputString)) {
    const pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString!);
  }

  return isInputStringValid ? null : AppStrings.errMsgPleaseEnterValidEmail;
}

String? arePasswordsSame(String? password, String? confirmPassword) {
  bool arePasswordsMatching = password == confirmPassword;

  return arePasswordsMatching ? null : AppStrings.errMsgPasswordsDoNotMatch;
}
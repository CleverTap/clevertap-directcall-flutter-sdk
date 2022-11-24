import 'package:clevertap_signedcall_flutter/src/constants.dart';

///Represents the SignedCall Plugin errors
class SignedCallError {
  late int errorCode;
  late String errorMessage;
  late String errorDescription;

  SignedCallError.fromMap(Map resultMap) {
    errorCode = resultMap[keyErrorCode];
    errorMessage = resultMap[keyErrorMessage];
    errorDescription = resultMap[keyErrorDescription];
  }

  @override
  String toString() {
    return 'SignedCallError{errorCode: $errorCode, errorMessage: $errorMessage, errorDescription: $errorDescription}';
  }
}

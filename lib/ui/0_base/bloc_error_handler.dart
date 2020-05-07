import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:repairservices/data/api/remote/result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:repairservices/Utils/extensions.dart';

class ErrorHandlerBloC {
  BehaviorSubject<String> _errorMessageController = new BehaviorSubject();

  Stream<String> get errorMessageStream => _errorMessageController.stream;

  void showErrorMessage(Result res) {
    String errorMessage = (res as ResultError).error;
    Fluttertoast.showToast(msg: errorMessage, toastLength: Toast.LENGTH_LONG);
  }

  onError(dynamic error) {
    if (error != null)
      _errorMessageController.sinkAddSafe(getResponseError(error));
    else
      clearError();
  }

  String getResponseError(dynamic error) {
//    if (error is SocketException) {
//      return R.string.error_check_your_connection;
//    }
//    if (error is ServerException) {
//      return error.message;
//    } else {
//      return error.toString();
//    }
    return error.toString();
  }

  clearError() {
    _errorMessageController.sinkAddSafe(null);
  }

  void disposeErrorHandlerBloC() {
    print('Error Handler Dispose');
    _errorMessageController.close();
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:retry/retry.dart';
import '../../env.dart';
import '../common_dtos/reponse_dto.dart';
import '../helpers/network_error_message_helper.dart';
import '../services/loggy_service.dart';
import 'api_cancel_token_manager.dart';
import 'api_constants.dart';
import 'dio_client.dart';

enum MethodType {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete("DELETE");

  const MethodType(this.type);

  final String type;
}

class ApiService {
  static final ApiService _singleton = ApiService._internal();

  factory ApiService() => _singleton;

  ApiService._internal();

  Future requestGetApi({
    required String endPoint,
  }) {
    try {
      return _requestApi(
        endPoint: endPoint,
        method: MethodType.get,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future _requestApi(
      {required MethodType method,
      required String endPoint,
      Map<String, dynamic>? data,
      Map<String, dynamic>? header}) async {
    ApiCancelTokenManager apiCancelRequestManager = ApiCancelTokenManager();
    CancelToken cancelToken = apiCancelRequestManager.createToken(endPoint);
    late Response response;
    try {
      response = await retry(
          maxAttempts: 3,
          () async => await DioClient().dio.request(
                cancelToken: cancelToken,
                _getURL(endPoint),
                data: data,
                options: Options(
                  method: method.type,
                  headers: header,
                ),
              ),
          // Retry on SocketException or TimeoutException
          retryIf: (e) {
        log(
          'ERROR retryIf ==> $e',
        );
        return e is DioException &&
            (e.type != DioExceptionType.cancel &&
                e.type != DioExceptionType.badResponse);
      });
      apiCancelRequestManager.removeTokenFromMap(endPoint, cancelToken);

      //this will only enter here is the status code is 2xx. else it will enter catch block
      ResponseDto responseDto = ResponseDto.fromJson(
        response.data is String ? jsonDecode(response.data) : response.data,
      );
      return responseDto;
    } catch (e) {
      throw _errorMessageHandler(error: e);
    }
  }

  String _errorMessageHandler({error}) {
    String errorMessage;
    if (error is DioException) {
      errorMessage = NetworkErrorMessageHelper()
          .dioExceptionStatusMessage(error.type, error.response?.statusCode);
    } else {
      errorMessage = "$error";
    }
    myLog.errorLog('${errorMessage}', StackTrace.current,
        topic: '_errorMessageHandler');
    return errorMessage;
  }

  /// Returns full api url(Uri) using the Environment Variable
  String _getURL(String endPoint) {
    Env envVar = ENV().currentEnv;
    switch (envVar) {
      case Env.production:
        myLog.traceLog('PROD mode', topic: "Environment Mode");
        myLog.setLogLevel(Level.error);
        return "${ApiConstants.prod}$endPoint";
      case Env.staging:
        myLog.traceLog('STAGING mode', topic: "Environment Mode");
        myLog.setLogLevel(Level.warning);
        return ("${ApiConstants.staging}$endPoint");
      case Env.local:
        myLog.traceLog('LOCAL mode', topic: "Environment Mode");
        myLog.setLogLevel(Level.all);
        return ("${ApiConstants.local}$endPoint");
      default:
        myLog.traceLog('LOCAL mode', topic: "Environment Mode");
        myLog.setLogLevel(Level.all);
        return ("${ApiConstants.local}$endPoint");
    }
  }
}

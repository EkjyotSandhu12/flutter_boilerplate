import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_strings.dart';
import 'package:logger/logger.dart';
import 'package:retry/retry.dart';
import '../../env.dart';
import '../helpers/exceptions.dart';
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

  Future requestApi(
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
              options: Options(method: method.type, headers: header),
            ),
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is DioException && (e.type != DioExceptionType.cancel && e.type != DioExceptionType.badResponse),
      );
      apiCancelRequestManager.removeTokenFromMap(endPoint, cancelToken);
      if (response.statusCode == 200) {
        return jsonDecode(response.data);
      } else {
        _errorOrInvalidTokenHandler(response: response);
      }
    } catch (e) {
      try {
        _errorOrInvalidTokenHandler(response: response);
      } catch (e) {
       rethrow;
      }
    }
  }

  List<String> _authIgnoreEndPoints = [
    /*ApiConstants.login*/
  ];

  _errorOrInvalidTokenHandler({
    required Response response,
  }) {
    myLog.warningLog("${response.statusCode}",
        topic: "errorOrInvalidTokenHandler");

    if ((response.statusCode == 403 || response.statusCode == 401) &&
        !_authIgnoreEndPoints.contains(response.realUri.path)) {
      throw UnauthorizedException(AppStrings.unauthorized);
    }

    throw "Status Code: ${response.statusCode}\n${response.data}";
  }

  /// Returns full api url(Uri) using the Environment Variable
  String _getURL(String endPoint) {
    if (kReleaseMode) {
      Env envVar = ENV().currentEnv;
      switch (envVar) {
        case Env.production:
          myLog.infoLog('PROD mode', topic: "Environment Mode");
          myLog.setLogLevel(Level.error);
          return "${ApiConstants.prod}$endPoint";
        case Env.staging:
          myLog.infoLog('STAGING mode', topic: "Environment Mode");
          myLog.setLogLevel(Level.warning);
          return ("${ApiConstants.staging}$endPoint");
        case Env.local:
          myLog.infoLog('LOCAL mode', topic: "Environment Mode");
          myLog.setLogLevel(Level.all);
          return ("${ApiConstants.local}$endPoint");
        default:
          myLog.infoLog('LOCAL mode', topic: "Environment Mode");
          myLog.setLogLevel(Level.all);
          return ("${ApiConstants.local}$endPoint");
      }
    } else {
      myLog.infoLog('debug mode', topic: "Environment Mode");
      Loggy().setLogLevel(Level.all);
      return "${ApiConstants.local}$endPoint";
    }
  }
}

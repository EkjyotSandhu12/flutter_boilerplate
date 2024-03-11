import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/common/constants/app_strings.dart';
import 'package:logger/logger.dart';
import 'package:retry/retry.dart';
import '../../env.dart';
import '../helpers/exceptions.dart';
import '../services/loggy_service.dart';
import 'api_constants.dart';
import 'dio_client.dart';

class ApiService {
  static final ApiService _singleton = ApiService._internal();

  factory ApiService() => _singleton;

  ApiService._internal();

  Future requestApi(
      {required MethodType method,
      required String endPoint,
      Map<String, dynamic>? data,
      Map<String, dynamic>? header}) async {
    try {
      Response response = await retry(
        maxAttempts: 3,
        () async => await DioClient().dio.request(
              getURL(endPoint),
              data: data,
              options: Options(method: method.type, headers: header),
            ),
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is DioException,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.data);
      } else {
        _errorOrInvalidTokenHandler(response: response);
      }
    } catch (e) {
      rethrow;
    }
  }

  List<String> _authIgnoreEndPoints = [
    /*ApiConstants.login*/
  ];

  _errorOrInvalidTokenHandler({
    required Response response,
  }) async {
    Loggy().warningLog("${response.statusCode}",
        topic: "errorOrInvalidTokenHandler");

    if ((response.statusCode == 403 || response.statusCode == 401) &&
        !_authIgnoreEndPoints.contains(response.realUri.path)) {
      throw UnauthorizedException(AppStrings.unauthorized);
    }

    throw "Status Code: ${response.statusCode}\n${response.data}";
  }

  /// Returns full api url(Uri) using the Environment Variable
  String getURL(String endPoint) {
    if (kReleaseMode) {
      Env envVar = ENV().currentEnv;
      switch (envVar) {
        case Env.production:
          Loggy().infoLog('PROD mode', topic: "Environment Mode");
          Loggy().setLogLevel(Level.error);
          return "${ApiConstants.prod}$endPoint";
        case Env.staging:
          Loggy().infoLog('STAGING mode', topic: "Environment Mode");
          Loggy().setLogLevel(Level.warning);
          return ("${ApiConstants.staging}$endPoint");
        case Env.local:
          Loggy().infoLog('LOCAL mode', topic: "Environment Mode");
          Loggy().setLogLevel(Level.all);
          return ("${ApiConstants.local}$endPoint");
        default:
          Loggy().infoLog('LOCAL mode', topic: "Environment Mode");
          Loggy().setLogLevel(Level.all);
          return ("${ApiConstants.local}$endPoint");
      }
    } else {
      Loggy().infoLog('debug mode', topic: "Environment Mode");
      Loggy().setLogLevel(Level.all);
      return "${ApiConstants.local}$endPoint";
    }
  }
}

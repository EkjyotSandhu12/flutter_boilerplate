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
              options: Options(
                method: method.type,
                headers: header,
              ),
            ),
        // Retry on SocketException or TimeoutException
        retryIf: (e) =>
            e is DioException &&
            (e.type != DioExceptionType.cancel &&
                e.type != DioExceptionType.badResponse),
      );
      apiCancelRequestManager.removeTokenFromMap(endPoint, cancelToken);

      //this will only enter here is the status code is 2xx. else it will enter catch block
      return response.data is String
          ? jsonDecode(response.data)
          : response.data;
    } catch (e) {
      throw _errorMessageHandler(error: e);
    }
  }

  _errorMessageHandler({error}) {
    if (error is DioException) {
      return dioExceptionStatusMessage(error.type, error.response?.statusCode);
    } else {
      return NetworkException(message: error.toString());
    }
  }


  dioExceptionStatusMessage(
      DioExceptionType dioExceptionType, int? statusCode) {
    switch (dioExceptionType) {
      case DioExceptionType.cancel:
        return 'STATUS CODE : $statusCode :: Connection was cancelled';
      case DioExceptionType.connectionTimeout:
        return 'STATUS CODE : $statusCode :: Connection not established, connectionTimeout';
      case DioExceptionType.sendTimeout:
        return 'STATUS CODE : $statusCode :: Failed to send, sendTimeout';
      case DioExceptionType.receiveTimeout:
        return 'STATUS CODE : $statusCode :: Failed to receive, receiveTimeout';
      case DioExceptionType.badCertificate:
        return 'STATUS CODE : $statusCode :: Caused by an incorrect certificate';
      case DioExceptionType.connectionError:
        return 'STATUS CODE : $statusCode :: Caused by an incorrect certificate';
      case DioExceptionType.badResponse:
        return 'STATUS CODE : $statusCode :: Caused by an incorrect certificate';
      default:
        return statusErrorMessage(statusCode);
    }
  }


  String statusErrorMessage(int? statusCode) {
      switch (statusCode) {
        case 400:
          return "STATUS CODE : $statusCode | Bad Request: The server could not understand the request due to invalid syntax.";
        case 401:
          return "STATUS CODE : $statusCode | Unauthorized: The user must authenticate itself to get the requested response.";
        case 403:
          return "STATUS CODE : $statusCode | Forbidden: The user does not have access rights to the content.";
        case 404:
          return "STATUS CODE : $statusCode | Not Found: Can not find the requested resource.";
        case 405:
          return "STATUS CODE : $statusCode | Method Not Allowed: The method specified in the request is not allowed for the resource.";
        case 408:
          return "STATUS CODE : $statusCode | Request Timeout: The server timed out waiting for the request.";
        case 429:
          return "STATUS CODE : $statusCode | Too Many Requests: The user has sent too many requests in a given amount of time.";
        case 500:
          return "STATUS CODE : $statusCode | Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request.";
        case 502:
          return "STATUS CODE : $statusCode | Bad Gateway: The server received an invalid response from the upstream server while trying to fulfill the request.";
        case 503:
          return "STATUS CODE : $statusCode | Service Unavailable: The server is currently unable to handle the request due to temporary overloading or maintenance of the server.";
        case 504:
          return "STATUS CODE : $statusCode | Gateway Timeout: The server did not receive a timely response from the upstream server.";
        case 408:
          return "STATUS CODE : $statusCode | Request Timeout: The server timed out waiting for the request.";
        case 413:
          return "STATUS CODE : $statusCode | Payload Too Large: The request is larger than the server is willing or able to process.";
        case 414:
          return "STATUS CODE : $statusCode | URI Too Long: The URI provided was too long for the server to process.";
        case 415:
          return "STATUS CODE : $statusCode | Unsupported Media Type: The server does not support the media type that the request was made with.";
        case 500:
          return "STATUS CODE : $statusCode | Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request.";
        case 501:
          return "STATUS CODE : $statusCode | Not Implemented: The server either does not recognize the request method, or it lacks the ability to fulfill the request.";
        case 502:
          return "STATUS CODE : $statusCode | Bad Gateway: The server received an invalid response from the upstream server while trying to fulfill the request.";
        case 503:
          return "STATUS CODE : $statusCode | Service Unavailable: The server is currently unable to handle the request due to temporary overloading or maintenance of the server.";
        case 504:
          return "STATUS CODE : $statusCode | Gateway Timeout: The server did not receive a timely response from the upstream server.";
        default:
          return "STATUS CODE : $statusCode | Unknown Error: The server returned an unexpected status code or error.";
      }
    }

  /// Returns full api url(Uri) using the Environment Variable
  String _getURL(String endPoint) {
    if (kReleaseMode) {
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
    } else {
      myLog.traceLog('debug mode', topic: "Environment Mode");
      Loggy().setLogLevel(Level.all);
      return "${ApiConstants.local}$endPoint";
    }
  }


}

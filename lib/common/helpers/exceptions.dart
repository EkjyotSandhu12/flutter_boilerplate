import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException({
    this.statusCode,
    required this.message,
  });

  factory NetworkException.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.cancel:
        return NetworkException(
          statusCode: exception.response?.statusCode,
          message: 'Request cancelled prematurely',
        );
      case DioExceptionType.connectionTimeout:
        return NetworkException(
          statusCode: exception.response?.statusCode,
          message: 'STATUS CODE : ${exception.response?.statusCode} :: Connection not established, connectionTimeout',
        );
      case DioExceptionType.sendTimeout:
        return NetworkException(
          statusCode: exception.response?.statusCode,
          message: 'STATUS CODE : ${exception.response?.statusCode} :: Failed to send, sendTimeout',
        );
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          statusCode: exception.response?.statusCode,
          message: 'STATUS CODE : ${exception.response?.statusCode} :: Failed to receive, receiveTimeout',
        );
      case DioExceptionType.badCertificate:
        return NetworkException(
          statusCode: exception.response?.statusCode,
          message: 'STATUS CODE : ${exception.response?.statusCode} :: Caused by an incorrect certificate',
        );
      default:
        return NetworkException(
          statusCode: exception.response?.statusCode,
          message: ' Unknown network exception occurred ${exception.message}',
        );
    }
  }
}

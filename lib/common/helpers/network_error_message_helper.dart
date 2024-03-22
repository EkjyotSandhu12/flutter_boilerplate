import 'package:dio/dio.dart';

class NetworkErrorMessageHelper{

  dioExceptionStatusMessage(
      DioExceptionType dioExceptionType, int? statusCode) {
    switch (dioExceptionType) {
      case DioExceptionType.cancel:
        return '$statusCode :: Connection was cancelled';
      case DioExceptionType.connectionTimeout:
        return '$statusCode :: Connection not established, connectionTimeout';
      case DioExceptionType.sendTimeout:
        return '$statusCode :: Failed to send, sendTimeout';
      case DioExceptionType.receiveTimeout:
        return '$statusCode :: Failed to receive, receiveTimeout';
      case DioExceptionType.badCertificate:
        return '$statusCode :: Caused by an incorrect certificate';
/*      case DioExceptionType.connectionError:
        return '$statusCode :: Caused by an incorrect certificate';
      case DioExceptionType.badResponse:
        return '$statusCode :: Caused by an incorrect certificate';*/
      default:
        return statusErrorMessage(statusCode);
    }
  }

  String statusErrorMessage(int? statusCode) {
    String errorMessage;
    switch (statusCode) {
      case 400:
        errorMessage =
        "Bad Request: The server could not understand the request due to invalid syntax.";
      case 401:
        errorMessage =
        "Unauthorized: The user must authenticate itself to get the requested response.";
      case 403:
        errorMessage =
        "Forbidden: The user does not have access rights to the content.";
      case 404:
        errorMessage = "Not Found: Can not find the requested resource.";
      case 405:
        errorMessage =
        "Method Not Allowed: The method specified in the request is not allowed for the resource.";
      case 408:
        errorMessage =
        "Request Timeout: The server timed out waiting for the request.";
      case 429:
        errorMessage =
        "Too Many Requests: The user has sent too many requests in a given amount of time.";
      case 500:
        errorMessage =
        "Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request.";
      case 502:
        errorMessage =
        "Bad Gateway: The server received an invalid response from the upstream server while trying to fulfill the request.";
      case 503:
        errorMessage =
        "Service Unavailable: The server is currently unable to handle the request due to temporary overloading or maintenance of the server.";
      case 504:
        errorMessage =
        "Gateway Timeout: The server did not receive a timely response from the upstream server.";
      case 413:
        errorMessage =
        "Payload Too Large: The request is larger than the server is willing or able to process.";
      case 414:
        errorMessage =
        "URI Too Long: The URI provided was too long for the server to process.";
      case 415:
        errorMessage =
        "Unsupported Media Type: The server does not support the media type that the request was made with.";
      case 501:
        errorMessage =
        "Not Implemented: The server either does not recognize the request method, or it lacks the ability to fulfill the request.";
      default:
        errorMessage =
        "Unknown Error: The server returned an unexpected status code or error.";
    }
    return "$statusCode | $errorMessage";
  }

}
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiInterceptor extends Interceptor {

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    @override
    void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
      print('REQUEST[${options.method}] => PATH: ${options.path}');
      super.onRequest(options, handler);
    }

    @override
    void onResponse(Response response, ResponseInterceptorHandler handler) {
      print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      super.onResponse(response, handler);
    }

    @override
    Future onError(DioException err, ErrorInterceptorHandler handler) async {
      print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      super.onError(err, handler);
    }
}
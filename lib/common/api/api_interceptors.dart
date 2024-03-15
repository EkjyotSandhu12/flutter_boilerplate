import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/common/api/dio_client.dart';

import '../services/loggy_service.dart';
import '../values/global_variables.dart';
import 'api_cancel_token_manager.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String authToken = GlobalVariables().authToken;
    if (authToken.isNotEmpty) {
      options.headers["authorization"] = 'Bearer $authToken';
      options.headers["Content-Type"] = "application/json";
    }

    myLog.infoLog("URL: ${options.path},\nBody: ${options.data}  \n Headers: ${options.headers}",
        topic: "HTTP REQUEST");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    myLog.infoLog(
        "STATUS-CODE[${response.statusCode}] URL: ${response.requestOptions.path},\nBody: ${response.data} ",
        topic: "HTTP RESPONSE");

    if(response.statusCode == 401 || response.statusCode == 403){
      ApiCancelTokenManager().cancelAllRequests();
      //logout user
    }

    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    myLog.errorLog(
        "STATUS-CODE[${err.response?.statusCode}] URL: ${err.requestOptions.path}",
        topic: "REQUEST ERROR",
        StackTrace.current);

    super.onError(err, handler);
  }
}

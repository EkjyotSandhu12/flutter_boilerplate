import 'package:dio/dio.dart';

import '../services/loggy_service.dart';
import '../values/global_variables.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String authToken = GlobalVariables().authToken;
    if (authToken.isNotEmpty) {
      options.headers["authorization"] = 'Bearer $authToken';
      options.headers["Content-Type"] = "application/json";
    }

    Loggy().infoLog(
        "URL: ${options.path},\nBody: ${options.data}  \n Headers: ${options.headers}",
        topic: "HTTP REQUEST");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Loggy().warningLog(
        "STATUS-CODE[${response.statusCode}] URL: ${response.requestOptions.path},\nBody: ${response.data} ",
        topic: "HTTP RESPONSE");

    if(response.statusCode == 401 || response.statusCode == 403){
      // RouteService().loginNavigate();
    }

    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    Loggy().errorLog(
        "STATUS-CODE[${err.response?.statusCode}] URL: ${err.requestOptions.path}",
        topic: "REQUEST ERROR",
        StackTrace.current);

    super.onError(err, handler);
  }
}

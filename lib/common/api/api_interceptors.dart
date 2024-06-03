import 'package:dio/dio.dart';
import '../app_values/global_variables.dart';
import '../services/loggy_service.dart';
import 'api_cancel_token_manager.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String authToken = GlobalVariables().authToken;
    if (authToken.isNotEmpty) {
      options.headers["authorization"] = 'Bearer $authToken';
      options.headers["Content-Type"] = "application/json";
    }
    myLog.infoLog(
        "URL: ${options.path}, \nBody: ${apiInterceptorBodyPrinter(options.data)}  \n Headers: ${options.headers}",
        topic: "HTTP OnREQUEST");


    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    myLog.infoLog(
        "STATUS-CODE[${response.statusCode}] URL: ${response.requestOptions.path},\nBody: ${response.data} ",
        topic: "HTTP OnRESPONSE");

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
        topic: "API OnERROR",
        StackTrace.current);

    super.onError(err, handler);
  }
}

apiInterceptorBodyPrinter(dynamic body) {
  try {
    Map bodyData = {};
    if (body is FormData) {
      FormData formData = body;
      bodyData.addEntries(formData.fields);
      MapEntry mapEntry = MapEntry('${formData.files.first.key}',
          formData.files.map((e) => e.value.filename));
      bodyData.addEntries([mapEntry]);
    } else {
      bodyData = body;
    }
    return bodyData;
  }  catch (e) {
    return {};
  }
}

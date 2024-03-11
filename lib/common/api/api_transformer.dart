


import 'package:dio/dio.dart';

class MyTransformer extends BackgroundTransformer {
  @override
  Future<String> transformRequest(RequestOptions options) async {
      return super.transformRequest(options);
  }


  @override
  Future transformResponse(
      RequestOptions options,
      ResponseBody responseBody,
      ) async {
    return super.transformResponse(options, responseBody);
  }
}
import 'package:dio/dio.dart';
import 'api_interceptors.dart';
import 'api_transformer.dart';

class DioClient{
  static final DioClient _singleton = DioClient._internal();
  factory DioClient() => _singleton;
  DioClient._internal();


  final Dio dio = Dio(
      BaseOptions(
          connectTimeout: timeOut,
          sendTimeout: timeOut
      )
  )
    ..interceptors.addAll([
      ApiInterceptor(),
    ])
    ..transformer = MyTransformer();

  static Duration timeOut = const Duration(seconds: 60);

}
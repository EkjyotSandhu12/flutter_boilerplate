

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../env.dart';
import '../services/loggy_service.dart';
import 'api_constants.dart';
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
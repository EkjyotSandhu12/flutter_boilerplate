import 'dart:developer';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class Loggy {


  static final Loggy _singleton = Loggy._internal();

  factory Loggy() {
    return _singleton;
  }

  Loggy._internal();


  Logger logger = Logger(
    // output: FileOutput(), //to print data in local storage file
    printer: SimplePrinter(), );

  setLogLevel(Level level) {
    Logger.level = level;
  }

  traceLog(String log, {String topic = "Trace"}) {
    if(!kIsWeb && Platform.isIOS){
      print("[${topic}] ==> $log");
    }else {
      logger.t("[${topic}] ==> $log");
    }
  }

  debugLog(String log, {String topic = "debug"}) {

    if(!kIsWeb && Platform.isIOS){
      print("[${topic}] ==> $log");
    }else {
      logger.d("[${topic}] ==> $log");
    }
  }

  infoLog(String log, {String topic = "info"}) {

    if(!kIsWeb && Platform.isIOS){
      print("[${topic}] ==> $log");
    }else{
      logger.i("[${topic}] ==> $log");
    }

  }

  warningLog(String log, {String topic = "warning"}) {

    if(!kIsWeb && Platform.isIOS){
      print("[${topic}] ==> $log");
    }else {
      logger.w("[${topic}] ==> $log");
    }
  }

  errorLog(String log, StackTrace stack) {
    if(!kIsWeb && Platform.isIOS){
      print("[ERROR] ==> $log");
    }else {
      logger.e(log, stackTrace: stack, );
    }
    // if (!kIsWeb) {
    //   FirebaseCrashlytics.instance.recordError(log, stack, fatal: false, reason: classMethod);
    // }
  }

  wftLog(String log, StackTrace? stack, {String topic = "wft"}) {
    logger.f("[${topic}] ==> $log");
  }
}
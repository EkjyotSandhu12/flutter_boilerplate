import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';


Loggy myLog = Loggy();

class Loggy {
  static final Loggy _singleton = Loggy._internal();
  factory Loggy() => _singleton;
  Loggy._internal();


  Logger logger = Logger(
    // output: FileOutput(), //to print data in local storage file
    printer: SimplePrinter(), );

  setLogLevel(Level level) {
    Logger.level = level;
  }

  traceLog(String log, {String topic = "Trace"}) {
    kIsWeb ? debugPrint("[$topic] :: $log") : Platform.isIOS ? print("[$topic] ==> $log") :logger.t("[${topic}] ==> $log") ;
  }

  debugLog(String log, {String topic = "debug"}) {
    kIsWeb ? debugPrint("[$topic] :: $log") : Platform.isIOS ? print("[$topic] ==> $log") :logger.d("[${topic}] ==> $log");
  }

  infoLog(String log, {String topic = "info"}) {
    kIsWeb ? debugPrint("[$topic] :: $log") : Platform.isIOS ? print("[$topic] ==> $log") :logger.i("[${topic}] ==> $log") ;
  }

  warningLog(String log, {String topic = "warning"}) {
    kIsWeb ? debugPrint("[$topic] :: $log") : Platform.isIOS ? print("[$topic] ==> $log") :logger.w("[${topic}] ==> $log") ;
  }

  errorLog(String log, StackTrace stack, {String topic = 'ERROR'}) {
    kIsWeb ? debugPrint("[$topic] :: $log |:| $stack") : Platform.isIOS ? print("[$topic] ==> $log |:| $stack") :logger.e("[$topic] ==> $log", stackTrace: stack) ;
  }

}
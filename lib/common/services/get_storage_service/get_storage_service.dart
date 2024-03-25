import 'dart:convert';
import '../../services/get_storage_service/storage_keys.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import '../loggy_service.dart';

enum SaveDataType { map, int, string, list, bool }

class GetStorageService {
  static final GetStorageService _singleton = GetStorageService._internal();

  factory GetStorageService() {
    return _singleton;
  }

  GetStorageService._internal();

  initialize() async {
    await GetSecureStorage.init(password: StorageKeys.securePassword);
    box = GetSecureStorage(password: StorageKeys.securePassword);
  }

  late GetSecureStorage box;

  Future<bool> removeKey(String key) async {
    try {
      await box.remove(key);
      myLog.infoLog('${key} ', topic: 'removeKey');
    } catch (e, stack) {
      myLog.errorLog(e.toString(), stack);
      return false;
    }
    return true;
  }

  _readData(String key) async {
    try {
      var dataRead = await box.read(key);
      myLog.infoLog('Key:: $key \nData :: $dataRead', topic: 'dataRead');
      return dataRead;
    } on Exception catch (e) {
      rethrow;
    }
  }

  _writeData(String key, dynamic data) async {
    try {
      await box.write(key, data);
      myLog.infoLog('Key:: $key \nData:: $data', topic: 'dataWrite');
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<bool> write(
      {required dynamic data,
      required String key,
      required SaveDataType saveDataType}) async {
    try {
      switch (saveDataType) {
        case SaveDataType.map:
          if (data is Map) {
            await _writeData(key, jsonEncode(data));
            return true;
          } else {
            myLog.errorLog(
                'data is the type of ${data.runtimeType} || needed => MAP',
                StackTrace.current);
          }
          break;
        case SaveDataType.string:
          if (data is String) {
            await _writeData(key, data);
            return true;
          } else {
            myLog.errorLog(
                'data is the type of ${data.runtimeType} || needed => STRING',
                StackTrace.current);
          }
          break;
        case SaveDataType.bool:
          if (data is bool) {
            int v = data ? 1 : 0;
            await _writeData(key, v);
            return true;
          } else {
            myLog.errorLog(
                'data is the type of ${data.runtimeType} || needed => BOOL',
                StackTrace.current);
          }
          break;
        case SaveDataType.int:
          if (data is int) {
            await _writeData(key, data);
            return true;
          } else {
            myLog.errorLog(
                'data is the type of ${data.runtimeType} || needed => INT',
                StackTrace.current);
          }
          break;
        case SaveDataType.list:
          //list can contain of type STRING,INT,MAP,DOUBLE,BOOLEAN
          if (data is List) {
            Map myMap = {key: data};
            await _writeData(key, jsonEncode(myMap));
            break;
          } else {
            myLog.errorLog(
                'data is the type of ${data.runtimeType} || needed => LIST',
                StackTrace.current);
          }
          break;
        default:
          myLog.errorLog('SaveDataType was not mentioned', StackTrace.current);
          break;
      }
    } catch (e) {
      myLog.errorLog(e.toString(), StackTrace.current);
      return false;
    }
    myLog.errorLog('Something went wrong', StackTrace.current);
    return false;
  }

  Future? read(
      {required String key, required SaveDataType saveDataType}) async {
    dynamic result = await _readData(key);
    try {
      switch (saveDataType) {
        case SaveDataType.map:
          if (result is String) {
            return jsonDecode(result);
          } else {
            myLog.errorLog(
                'fetched data was type of ${result.runtimeType} || needed => STRING',
                StackTrace.current);
          }
          break;
        case SaveDataType.string:
          if (result is String) {
            return result;
          } else {
            myLog.errorLog(
                'fetched data was type of ${result.runtimeType} || needed => STRING',
                StackTrace.current);
          }
          break;
        case SaveDataType.bool:
          if (result is int) {
            return result == 1 ? true : false;
          } else {
            myLog.errorLog(
                'fetched data was type of ${result.runtimeType} || needed => INT',
                StackTrace.current);
          }
          break;
        case SaveDataType.int:
          if (result is int) {
            return result;
          } else {
            myLog.errorLog(
                'fetched data was type of ${result.runtimeType} || needed => INT',
                StackTrace.current);
          }
          break;
        case SaveDataType.list:
          //list can contain of type STRING,INT,MAP,DOUBLE,BOOLEAN
          if (result is String) {
            return jsonDecode(result)[key];
          } else {
            myLog.errorLog(
                'fetched data was type of ${result.runtimeType} || needed => STRING',
                StackTrace.current);
          }
          break;
        default:
          myLog.errorLog('SaveDataType was not mentioned', StackTrace.current);
      }
    } catch (e) {
      myLog.errorLog(e.toString(), StackTrace.current);
      return null;
    }
    myLog.errorLog('Something went wrong', StackTrace.current);
    return null;
  }

  Future<bool> nukePrefs() async {
    try {
      await box.erase();
    } catch (e, stack) {
      myLog.errorLog(e.toString(), stack);
      return false;
    }
    return true;
  }
}

import 'dart:convert';
import 'package:flutter_boilerplate/common/services/get_storage_service/storage_keys.dart';
import 'package:get_secure_storage/get_secure_storage.dart';

import '../loggy_service.dart';

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
      Loggy().infoLog('${key} ', topic: 'removeKey');
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return false;
    }
    return true;
  }

  Future<bool> writeMap(String key, Map map) async {
    try {
      await writeData(key, jsonEncode(map));
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return false;
    }
    return true;
  }

  Future<Map?> readMap(String key) async {
    try {
      String? result = await readData(key);
      if (result != null) {
        return jsonDecode(result);
      }
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return null;
    }
    return null;
  }

  Future<bool> writeList(String key, List values) async {
    Map myMap = {key: values};
    try {
      await writeData(key, jsonEncode(myMap));
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return false;
    }
    return true;
  }

  Future<List?> readList(String key) async {
    try {
      String? result = await readData(key);
      if (result != null) {
        return jsonDecode(result)[key];
      }
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return null;
    }
    return null;
  }

  Future<bool> writeString(String key, String value) async {
    try {
      await writeData(key, value);
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return false;
    }
    return true;
  }

  Future<String?> readString(String key) async {
    try {
      return await readData(key);
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return null;
    }
  }

  Future<bool> writeBool(String key, bool value) async {
    int v = value ? 1 : 0;
    try {
      await writeData(key, v);
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return false;
    }
    return true;
  }

  Future<bool?> readBool(String key) async {
    try {
      int? v = await readData(key);
      if (v != null) {
        return v == 1 ? true : false;
      }
      return null;
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return null;
    }
  }

  Future<bool> writeInt(String key, int value) async {
    try {
      await writeData(key, value.toString());
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return false;
    }
    return true;
  }

  Future<int?> readInt(String key) async {
    try {
      String? value = await readData(key);
      if (value != null) {
        return int.parse(value);
      }
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return null;
    }
    return null;
  }

  Future<bool> nukePrefs() async {
    try {
      await box.erase();
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return false;
    }
    return true;
  }

  Future<bool> setRefreshToken(String token) async {
    try {
      await writeData(StorageKeys.refreshToken, token);
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return false;
    }
    return true;
  }

  Future<String> getRefreshToken() async {
    String value = '';
    try {
      value = (await readString(
            StorageKeys.refreshToken,
          )) ??
          '';
    } catch (e, stack) {
      Loggy().errorLog(e.toString(), stack);
      return value;
    }
    return value;
  }

  readData(String key) async {
    try {
      var dataRead = await box.read(key);
      Loggy().infoLog('Key:: $key \nData :: $dataRead', topic: 'dataRead');
      return dataRead;
    } on Exception catch (e) {
      rethrow;
    }
  }

  writeData(String key, dynamic data) async {
    try {
      await box.write(key, data);
      Loggy().infoLog('Key:: $key \nData:: $data', topic: 'dataWrite');
    } on Exception catch (e) {
      rethrow;
    }
  }
}

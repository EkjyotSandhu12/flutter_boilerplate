import 'package:flutter_boilerplate/common/services/loggy_service.dart';
import 'package:path_provider/path_provider.dart';

class PathProviderService {
  static final PathProviderService _singleton = PathProviderService._internal();
  factory PathProviderService() => _singleton;
  PathProviderService._internal();


  String? _applicationDirectoryPath;
  String? _tempDirectoryPath;

  init() async {
    _applicationDirectoryPath = await _getTempPath();
    _tempDirectoryPath = await _getApplicationDirPath();
  }

  _getTempPath() async {
    try {
      _tempDirectoryPath = _tempDirectoryPath??(await getTemporaryDirectory()).path;
      return _tempDirectoryPath;
    }  catch (e,s) {
      myLog.errorLog('getCachePath Failed :: $e', s);
      return null;
    }
  }

  _getApplicationDirPath() async {
    try {
      _applicationDirectoryPath = _applicationDirectoryPath??(await getApplicationDocumentsDirectory()).path;
      return _applicationDirectoryPath;
    } catch (e,s) {
      myLog.errorLog('getApplicationDirPath Failed :: $e', s);
      return null;
    }
  }

  get getTempPath async => await _getTempPath();
  get getApplicationDirPath async => await _getApplicationDirPath();

}





import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import '../services/path_provider_service.dart';

import 'loggy_service.dart';

class FileService{

  PathProviderService pathProviderService = PathProviderService();


  Future<String?> saveXFileIntoApplicationDirectory(XFile file) async {
    try {
      final String appDocumentsDirPath = pathProviderService.getApplicationDirPath;
      String path = '${appDocumentsDirPath}/${file.path.split('/').last}';
      await file.saveTo(path);
      myLog.infoLog('$path', topic: 'Files Saved To');
      return path;
    }  catch (e) {
      myLog.errorLog(
          'Unable to save file in application directory', StackTrace.current);
      return null;
    }
  }

  Future<String?> saveUInt8ListIntoApplicationDirectory(Uint8List bytes) async {
    try {
      final String appDocumentsDirPath = pathProviderService.getApplicationDirPath;
      File file = await File(
          '$appDocumentsDirPath/${DateTime.now().microsecondsSinceEpoch}.png')
          .writeAsBytes(bytes, mode: FileMode.writeOnly);
      myLog.infoLog(file.path, topic: 'Files Saved To');
      return file.path;
    }  catch (e,s) {
      myLog.errorLog(
          'Unable to save file in application directory $s', StackTrace.current);
      return null;
    }
  }

  Future<String?> saveUInt8ListIntoCacheDirectory({required Uint8List bytes, required String fileNameWithExtension}) async {
    try {
      final String appCacheDirPath = await pathProviderService.getCacheDirPath;
      File file = await File(
          '$appCacheDirPath/${fileNameWithExtension}')
          .writeAsBytes(bytes, mode: FileMode.writeOnly);
      myLog.infoLog(file.path, topic: 'Files Saved To');
      return file.path;
    }  catch (e,s) {
      myLog.errorLog(
          'Unable to save file in application directory $e $s', StackTrace.current);
      return null;
    }
  }

  clearCacheDirectory() async {
    try {
      myLog.infoLog('Clearing cache directory', topic: 'clearCacheDirectory');
      (await getApplicationCacheDirectory()).delete(recursive: true);
    }  catch (e,s) {
      myLog.errorLog('$e', s,topic: 'clearCacheDirectory');
    }
  }


  Future deleteFile(String filePath) async {
    myLog.infoLog('$filePath', topic: 'deleteFile');
    try {
      await File(filePath).delete();
    }  catch (e) {
      myLog.warningLog('$e :: Path > $filePath', topic: 'Failed To Delete File');
    }
  }

}
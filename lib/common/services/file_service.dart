



import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter_boilerplate/common/services/path_provider_service.dart';

import 'loggy_service.dart';

class FileService{

  PathProviderService pathProviderService = PathProviderService();


  Future<String?> saveXFileIntoApplicationDirectory(XFile file) async {
    try {
      final String appDocumentsDirPath = pathProviderService.getApplicationDirPath();
      String path = '${appDocumentsDirPath}/${file.path.split('/').last}';
      await file.saveTo(path);
      myLog.infoLog('$path', topic: 'Files Saved To');
      return path;
    } on Exception catch (e) {
      myLog.errorLog(
          'Unable to save file in application directory', StackTrace.current);
      return null;
    }
  }

  Future<String?> saveUInt8ListIntoApplicationDirectory(Uint8List bytes) async {
    try {
      final String appDocumentsDirPath = pathProviderService.getApplicationDirPath();
      File file = await File(
          '$appDocumentsDirPath/${DateTime.now().microsecondsSinceEpoch}.png')
          .writeAsBytes(bytes, mode: FileMode.writeOnly);
      Loggy().infoLog(file.path, topic: 'Files Saved To');
      return file.path;
    } on Exception catch (e) {
      Loggy().errorLog(
          'Unable to save file in application directory', StackTrace.current);
      return null;
    }
  }


  Future deleteFile(String filePath) async {
    Loggy().infoLog('$filePath', topic: 'deleteFile');
    try {
      await File(filePath).delete();
    }  catch (e) {
      Loggy().warningLog('$e :: Path > $filePath', topic: 'Failed To Delete File');
    }
  }

}
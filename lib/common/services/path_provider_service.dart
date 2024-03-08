import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'loggy_service.dart';

class PathProviderService {


  String? applicationDirectoryPath;
  String? tempDirectoryPath;

  init() async {
    tempDirectoryPath = (await getApplicationCacheDirectory()).path;
    applicationDirectoryPath = (await getApplicationDocumentsDirectory()).path;
  }

  Future<String?> getTemporaryPath() async {
    try {
      return tempDirectoryPath??((await getApplicationCacheDirectory()).path);
    } on Exception catch (e) {
      Loggy().errorLog(
          'Unable to getTemporaryPath', StackTrace.current);
      return null;
    }
  }

  Future<String?> saveXFileIntoApplicationDirectory(XFile file) async {
    try {
      final String appDocumentsDirPath = applicationDirectoryPath??(await getApplicationDocumentsDirectory()).path;
      String path = '${appDocumentsDirPath}/${file.path.split('/').last}';
      await file.saveTo(path);
      Loggy().infoLog('$path', topic: 'Files Saved To');
      return path;
    } on Exception catch (e) {
      Loggy().errorLog(
          'Unable to save file in application directory', StackTrace.current);
      return null;
    }
  }

  Future<String?> saveUInt8ListIntoApplicationDirectory(Uint8List bytes) async {
    try {
      final String appDocumentsDirPath = applicationDirectoryPath??(await getApplicationDocumentsDirectory()).path;
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

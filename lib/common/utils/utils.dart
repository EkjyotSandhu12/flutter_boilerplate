import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/common_widgets/app_widgets/custom_circular_loader_widget.dart';
import 'package:flutter_boilerplate/common/route/route_service.dart';
import '../utils/screen_utils.dart';
import 'package:intl/intl.dart';
enum FileType { pdf, image }
class Utils {


  ///==> WIDGET RELATED
  //we are using timer here as, the keyboard takes time to open.
  static Timer? timer;
  static ensureVisibleTextField(BuildContext context,{int? tries, Duration? eachTryDuration, Duration? scrollSpeed}) {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer.periodic(
      eachTryDuration??Duration(milliseconds: 50),
          (timer) {
        if (timer.tick > (tries??20)) {
          timer.cancel();
        } else if (ScreenUtils.viewInsetsBottom(context) > 0) {
          Future.delayed(
            Duration(milliseconds: 250),
                () {
              timer.cancel();
            },
          );
        }
        Scrollable.ensureVisible(context,
            duration: scrollSpeed?? Duration(milliseconds: 200), alignment: .1);
      },
    );
  }
  static bool isFocusing = false;
  static ensureVisibleOnce(BuildContext context) async {
    if (isFocusing) return;
    isFocusing = true;
    await Scrollable.ensureVisible(context,
        duration: const Duration(milliseconds: 150), alignment: .5);
    isFocusing = false;
  }
  static hideKeyboard() {
    // myLog.traceLog("KeyBoard Hide", topic: "hideKeyboard");
    FocusManager.instance.primaryFocus?.unfocus();
  }


  static bool isScrollPositionPastLimit(ScrollController controller,
      {double limitPercentage = 80}) {
    //if screen is scrolled more than 80 percent, then it will return true.
    return controller.position.pixels >
        (controller.position.maxScrollExtent * (10 / limitPercentage));
  }

  static getWidgetHeight(BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;
    return box.size.height;
  }

  static getWidgetWidth(BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;
    return box.size.width;
  }

  static getWidgetOffset(BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    double y = position.dy;
    double x = position.dx;
    return Offset(x, y);
  }

  ///==> LOGIC RELATED

  static Future<String?> networkImageToBase64(String imageUrl) async {
/*    try {
      HttpService hs = HttpService();
      http.Response? response = await hs.getResponse(imageUrl);
      Uint8List? bytes = response?.bodyBytes;
      return bytes == null ? null : base64Encode(bytes);
    } catch (e) {
      kLog("networkImageToBase64 Error --> $e");
      return null;
    }*/
  }

  static Color randomColorGenerator() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  static String bytesToReadableSize(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static String bytesToReadableSizeNoSuffix(int bytes, int decimals) {
    if (bytes <= 0) return "0";
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)}';
  }

  static int bytesToMb(int bytes) {
    return (bytes / 1000000).floor();
  }

  static dateTimeToString(DateTime? dt) {
    if (dt != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);

      final aDate = DateTime(dt.year, dt.month, dt.day);
      if (aDate == today) {
        return "Today at ${DateFormat.jm().format(dt)}";
      } else if (aDate == yesterday) {
        return "Yesterday at ${DateFormat.jm().format(dt)}";
      } else {
        return "${DateFormat.yMMMMd().format(dt)} at ${DateFormat.jm().format(dt)}";
      }
    } else {
      return "";
    }
  }

  showDialogUntilConditionIsTrue(BuildContext context,
      {required bool Function() condition, required String title}) async {
    if (condition() != true) return;
    bool isPopped = false;
    showDialog(
      context: context,
      builder: (context) => CustomCircularLoaderWidget(),
    ).then((value) => isPopped = true);

    while (true) {
      await Future.delayed(const Duration(milliseconds: 50));
      if(isPopped){
        break;
      }
      if (condition() != true) {
        if (!isPopped) {
          RouteService().pop();
        }
        break;
      }
    }
  }

  static convertSecondsToMinuteSecond(int seconds) {
    int minute = seconds ~/ 60;
    int secondsInMinute = (seconds - (seconds ~/ 60 * 60)).toInt();
    return "${minute}m ${secondsInMinute}s";
  }

  static String getFileNameExtension({required String fileName}) {
    String extension = fileName.split('.').last.toLowerCase();

    return extension;
  }

  static bool isFileVideo({required String filePath}) {
    String extension = filePath.split('.').last.toLowerCase();
    // kLog("Selected Video File Extension -> $extension");
    List<String> videoExtensions = [
      'avi',
      'flv',
      'mkv',
      'mov',
      'mp4',
      'mpeg',
      'webm',
      'ogg',
      'asf',
      'wmv',
      'ts',
      '3gp'
    ];

    if (videoExtensions.contains(extension)) {
      return true;
    } else {
      return false;
    }
  }

  static String getFileNameFromPath(String filePath) {
    return filePath.split('/').last;
  }

  //output => '1st, 2nd and 3rd'
  static String numberToReadableString(List<int> number) {


    if(number.length == 1){
      return '${addSuffixToNumber(number.first)}';
    }

    if(number.length == 2){
      return '${addSuffixToNumber(number.first)} and ${addSuffixToNumber(number[1])}';
    }


    String string = '';

    number.forEach(
          (num) {
        if (number.indexOf(num) == number.length - 1) {
          string += 'and ${addSuffixToNumber(num)}';
        } else {
          string +=
          '${addSuffixToNumber(num)}${number.indexOf(num) > (number.length) ? ' ' : ', '}';
        }
      },
    );
    return string;
  }

  //output => '1st'
  static String addSuffixToNumber(int number) {
    String suffix;

    // Determine the suffix based on the last digit of the number
    switch (number % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
        break;
    }
    // Return the number with the appropriate suffix
    return number.toString() + suffix;
  }

  static bool doesArrayContainsValue(
      {required List<String> array, required String value}) {
    for (var element in array) {
      if (element.contains(value)) {
        return true;
      }
    }
    return false;
  }

  static bool doesValueContainsAnyArrayWords(
      {required List<String> array, required String value}) {
    for (var element in array) {
      if (value.contains(element)) {
        return true;
      }
    }
    return false;
  }

  //FILE
  static FileType? checkFileType(String fileNameWithExtension) {
    final extension = fileNameWithExtension.split('.').last.toLowerCase();
    // Loggy().traceLog('extension => $extension');
    if (extension.toLowerCase().contains('jpg') ||
        extension.toLowerCase().contains('jpeg') ||
        extension.toLowerCase().contains('png')) {
      return FileType.image;
    } else if (extension.toLowerCase().contains('pdf')) {
      return FileType.pdf;
    }
    return null;
  }

  static String getFileNameFromFilePath(String filePath) {
    return filePath.split('/').last;
  }
  static Future<Uint8List> fileToUint8List(File file) async {
    var bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
  }
  static mutliDArrayTo2Darray(List multiArray) {
    List singleArray = [];
    for (var list1 in multiArray) {
      for (var list2 in list1) {
        singleArray.add(list2);
      }
    }
    return singleArray;
  }

  ///==> NUMBERS/MATHS RELATED
  static int randomInt() {
    return DateTime.now().millisecondsSinceEpoch;
  }
  static bool isStringOnlyNumbers(String input) {
    final RegExp regex = RegExp(r'^\d+$');
    return regex.hasMatch(input);
  }


  ///==> SPECIFIC PACKAGE RELATED
  //camera
  static cameraCapturedImagePreview(
      {required CameraLensDirection cameraLensDirection,
        required Widget child}) {
    return Transform(
      alignment: Alignment.center,
      transform: cameraLensDirection == CameraLensDirection.back
          ? Matrix4.identity()
          : Matrix4.rotationY(pi),
      child: child,
    );
  }
}

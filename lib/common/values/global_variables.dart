
//variables that will change over time
import 'package:camera/camera.dart';

class GlobalVariables{
  static final GlobalVariables _singleton = GlobalVariables._internal();
  factory GlobalVariables() => _singleton;
  GlobalVariables._internal();


  List<CameraDescription> cameras = [];


  String authToken = '';
  //String userName = '';

}
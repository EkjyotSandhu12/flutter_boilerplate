import 'package:flutter/material.dart';
import '../route/route_service.dart';
import '../services/loggy_service.dart';

class LoadingIndicatorNotifier with ChangeNotifier {
  ValueNotifier<bool> update = ValueNotifier<bool>(false);
}

LoadingIndicatorNotifier loadingIndicatorNotifier = LoadingIndicatorNotifier();

showLoadingIndicator() {
  Loggy().infoLog("ENABLED", topic: "LoadingIndicator");
  loadingIndicatorNotifier.update.value = true;
}

hideLoadingIndicator() {
  Loggy().infoLog("DISABLED", topic: "LoadingIndicator");
  loadingIndicatorNotifier.update.value = false;
}

///==> DIALOG LOADER -> UN-POPABLE DIALOG BOX WHICH CONTAINS LOADER IN BETWEEN
bool isLoaderDialogShowing = false;
//DO NOT PERFORM ANY NAV.POP() inside of futureFunction that you passed
//DO NOT perform any showDIALOG/navigation inside of futureFunction that you passed
Future showAwaitLoaderDialog(
    {required Function futureFunction, required BuildContext context}) async {
  // ShowDialog().showLoaderDialog(context, key: _dialogKey);
  isLoaderDialogShowing = true;
  try {
    var data = await futureFunction();
    if(isLoaderDialogShowing){
      RouteService().pop(context);
      isLoaderDialogShowing = false;
    }
    isLoaderDialogShowing = false;
    return data;
  } catch (e) {
    if(isLoaderDialogShowing){
      RouteService().pop(context);
      isLoaderDialogShowing = false;
    }
    rethrow;
  }
}

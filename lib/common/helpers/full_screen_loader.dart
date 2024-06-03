import 'package:flutter/material.dart';
import '../components/app_widgets/custom_circular_loader_widget.dart';
import '../route/route_service.dart';
import '../services/loggy_service.dart';

class LoadingIndicatorNotifier with ChangeNotifier {
  ValueNotifier<bool> update = ValueNotifier<bool>(false);
}

LoadingIndicatorNotifier loadingIndicatorNotifier = LoadingIndicatorNotifier();

showLoadingIndicator() {
  myLog.infoLog("ENABLED", topic: "LoadingIndicator");
  loadingIndicatorNotifier.update.value = true;
}

hideLoadingIndicator() {
  myLog.infoLog("DISABLED", topic: "LoadingIndicator");
  loadingIndicatorNotifier.update.value = false;
}

///==> DIALOG LOADER -> UN-POPABLE DIALOG BOX WHICH CONTAINS LOADER IN BETWEEN
bool isLoaderDialogShowing = false;
//DO NOT PERFORM ANY NAV.POP() inside of futureFunction that you passed
//DO NOT perform any showDIALOG/navigation inside of futureFunction that you passed
Future showAwaitLoaderDialog(
    {required Function futureFunction,required BuildContext context}) async {
  showLoaderDialog(context);
  isLoaderDialogShowing = true;
  try {
    var data = await futureFunction();
    if(isLoaderDialogShowing){
      RouteService().pop();
      isLoaderDialogShowing = false;
    }
    isLoaderDialogShowing = false;
    return data;
  } catch (e) {
    if(isLoaderDialogShowing){
      RouteService().pop();
      isLoaderDialogShowing = false;
    }
    rethrow;
  }

}


showLoaderDialog(BuildContext context) {
  showDialog(
    useRootNavigator: true,
    routeSettings: const RouteSettings(name: 'loaderDialog'),
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return PopScope(
        canPop: false,
        child: Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: const CustomCircularLoaderWidget(
            ),
          ),

      );
    },
  );
}
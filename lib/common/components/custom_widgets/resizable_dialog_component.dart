import 'package:flutter/material.dart';
import '../../services/reponsive_framework_service.dart';
import '../../utils/utils.dart';

//call showCustomResizableDialog, and pass the initial widget, height and width,
//then using the controller call updateDialogWidget, through which you can changes the height,width and widget of the dialog
//this will give cool animation

showCustomResizableDialog(
    BuildContext context, {
      required ResizableDialogController resizableDialogController,
    }) async {
  resizableDialogController.isDialogOpen = true;
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => ResizableDialogUI(
      resizableDialogController: resizableDialogController,
    ),
  );
  resizableDialogController.isDialogOpen = false;
}

class ResizableDialogController with ChangeNotifier {
  double initialHeight;
  double initialWidth;
  Widget initialWidget;
  bool isDialogOpen = false;

  ResizableDialogController({
    required this.initialHeight,
    required this.initialWidth,
    required this.initialWidget,
  });

  updateDialogWidget(
      double height,
      double width,
      Widget widget,
      ) {
    initialHeight = height;
    initialWidth = width;
    initialWidget = widget;
    notifyListeners();
  }

  Future waitForDialogToClose() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: 100));
      if (!isDialogOpen) {
        break;
      }
    }
    return;
  }
}

class ResizableDialogUI extends StatefulWidget {
  ResizableDialogUI({super.key, required this.resizableDialogController});

  final ResizableDialogController resizableDialogController;

  @override
  State<ResizableDialogUI> createState() => _ResizableDialogUIState();
}

class _ResizableDialogUIState extends State<ResizableDialogUI> {
  @override
  void initState() {
    widget.resizableDialogController.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveFrameworkService().globalResponsive(
      context,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            curve: Curves.easeOutQuint,
            height: widget.resizableDialogController.initialHeight,
            width: widget.resizableDialogController.initialWidth,
            child: AnimatedSwitcher(
              switchInCurve: Curves.easeOutQuint,
              switchOutCurve: Curves.easeOutQuint,
              child: SizedBox(
                key: ValueKey(Utils.randomInt()),
                child: widget.resizableDialogController.initialWidget,
              ),
              duration: Duration(
                milliseconds: 800,
              ),
            ),
            duration: Duration(
              milliseconds: 600,
            ),
          ),
        ),
      ),
    );
  }
}

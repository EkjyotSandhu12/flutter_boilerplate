import 'package:flutter/material.dart';
import '../../route/route_service.dart';
import '../../utils/screen_utils.dart';
import '../../services/dynamic_pixel_service.dart';


enum DropDownDirection {
  topLeftToTopRight,
  topRightToTopLeft,
  bottomLeftToBottomRight,
  bottomRightToBottomLeft,
  bottomCenterToBottomLeft,
  bottomCenterToBottomRight;

  getOffset({required RenderBox box, required double width, required BuildContext context}) {
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    double y = position.dy - dWidth(ScreenUtils.viewPaddingTop(context));  //we are only counting viewPaddingTop, as the coordinate with start from top-let.
    double x = position.dx - dWidth(ScreenUtils.viewPaddingRight(context)); //for any device with notch
    double widgetHeight = dWidth(box.size.height); //height of dropdown icon
    double widgetWidth = dWidth(box.size.width); //width of the dropdown icon
    width = dWidth(width); //the width of the dropDown Menu

    // myLog.traceLog("getOffset ${name}");
    // myLog.traceLog("widgetHeight ${widgetHeight}");
    // myLog.traceLog("width ${width}");
    // myLog.traceLog("widgetWidth ${widgetWidth}");

    switch (name) {
      case "topLeftToTopRight":
        return Offset(x, y);
        break;
      case "topRightToTopLeft":
        return Offset((x - width) + widgetWidth, y);
        break;
      case "bottomLeftToBottomRight":
        return Offset(x, y + widgetHeight);
        break;
      case "bottomRightToBottomLeft":
        return Offset((x - width) + widgetWidth, y + widgetHeight);
        break;
      case "bottomCenterToBottomLeft":
        return Offset((x - width) + (widgetWidth / 2), y + widgetHeight);
        break;
      case "bottomCenterToBottomRight":
        return Offset(x + widgetWidth / 2, y + widgetHeight);
        break;
    }
  }
}

showDropDownBelowWidget(
  BuildContext context, {
  required GlobalKey key,
  required Widget Function(String) listTileBuilder,
  required Widget Function(List<Widget>) dropDownBuilder,
  required List<String> dropDownOptions,
  required double width,
  Offset addOffset = Offset.zero,
  DropDownDirection? dropDownDirection,
}) async {
  RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
  Offset position = box.localToGlobal(Offset.zero); //this is global position of drop down button
  double y = position.dy;
  double x = position.dx;
  Offset offset = Offset(x, y);

  Widget dropDownUI = dropDownBuilder(
    dropDownOptions
        .map(
          (e) => listTileBuilder(e),
        )
        .toList(),
  );

  if (dropDownDirection != null) {
    offset = dropDownDirection.getOffset(box: box, width: width, context: context);
  }

  // myLog.traceLog("View padding Top ${Utils.viewPaddingTop(context)}");
  // myLog.traceLog("View padding Bottom ${Utils.viewPaddingBottom(context)}");
  // myLog.traceLog("View padding left ${Utils.viewPaddingLeft(context)}");
  // myLog.traceLog("View padding right ${Utils.viewPaddingRight(context)}");


  // offset += addOffset!;

 return await showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (_) => Container(
      child: DialogWidget(
        dropDownUI: dropDownUI,
        offset: offset,
        originalOrientation: MediaQuery.of(context).orientation,
      ),
    ),
  );
}

class DialogWidget extends StatefulWidget {
  DialogWidget({
    super.key,
    required this.dropDownUI,
    required this.originalOrientation,
    this.offset = Offset.zero,
  });

  final Widget dropDownUI;
  Offset offset;
  Orientation originalOrientation;

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation != widget.originalOrientation) {
      //if screen orientation changes
      RouteService().pop();
    }

    return Stack(
      children: [
        Positioned(
          top: (widget.offset.dy),
          left: (widget.offset.dx),
          child: widget.dropDownUI,
        ),
      ],
    );
  }
}

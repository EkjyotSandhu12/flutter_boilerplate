import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_metrics.dart';
import '../../utils/utils.dart';

class AnimatedSingleWidgetDropDown extends StatefulWidget {
  const AnimatedSingleWidgetDropDown({
    super.key,
    required this.dropDownWidget,
    required this.leadingWidget,
    required this.height,
    this.headerBodyGap,
    required this.onDropDownClick,
  });

  final double height;
  final Widget dropDownWidget;
  final Widget leadingWidget;
  final double? headerBodyGap;
  final Function(bool) onDropDownClick;

  @override
  State<AnimatedSingleWidgetDropDown> createState() =>
      _AnimatedSingleWidgetDropDownState();
}

class _AnimatedSingleWidgetDropDownState
    extends State<AnimatedSingleWidgetDropDown> {
  bool isOpened = false;

  GlobalKey titleKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          key: titleKey,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          duration: Duration(
            milliseconds: 150,
          ),
          child: InkWell(
            borderRadius:
                BorderRadius.circular(DesignMetrics().commonContainerRadius12),
            onTap: () {
              setState(() {
                isOpened = !isOpened;
                widget.onDropDownClick(isOpened);
              });
              if (isOpened)
                Utils.ensureVisibleTextField(
                  titleKey.currentState!.context,
                  tries: 10,
                  scrollSpeed: Duration(
                    milliseconds: 200,
                  ),
                  eachTryDuration: Duration(
                    milliseconds: 23,
                  ),
                );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: widget.leadingWidget),
                  SizedBox(
                    width: 12,
                  ),
                  AnimatedRotation(
                    turns: isOpened ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: AppColors().getIconColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: widget.headerBodyGap ?? 6,
        ),
        AnimatedContainer(
          alignment: Alignment.topCenter,
          height: isOpened ? widget.height : 0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            reverseDuration: const Duration(milliseconds: 100),
            child: isOpened
                ? Container(
                    key: const ValueKey(2),
                    child: widget.dropDownWidget,
                  )
                : const SizedBox(key: ValueKey(1)),
          ),
        ),
      ],
    );
  }
}

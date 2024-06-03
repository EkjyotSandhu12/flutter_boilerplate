import 'package:flutter/material.dart';

class ClickableWidgetOverlay extends StatelessWidget {
  ClickableWidgetOverlay({
    super.key,
    required this.widget,
    this.borderRadius,
    this.splashPadding,
    this.onTap,
  });

  final Widget widget;
  BorderRadius? borderRadius;
  Function? onTap;
  EdgeInsets? splashPadding;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: splashPadding??EdgeInsets.zero,
          child: widget,
        ),
        Positioned.fill(
          child: Material(
            color:  Colors.transparent,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: () {
                if( onTap!=null){
                  onTap!();
                }
              },
            ),
          ),
        ),
      ],
    );
  }


}

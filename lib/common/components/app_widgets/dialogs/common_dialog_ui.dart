import 'package:flutter/material.dart';
import '../../../route/route_service.dart';
import '../../../services/reponsive_framework_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/design_metrics.dart';
import '../../../utils/screen_utils.dart';

//Very simple dialog, which have fixed width and height, and like showing information, error, and so on.

class CommonDialogUI extends StatelessWidget {
  CommonDialogUI({
    super.key,
    required this.header,
    required this.body,
    this.footer,
    this.horPadding,
    this.showCloseIcon = false,
    this.makeHeightDynamic = false,
    this.height,
    this.width,
    this.bodyAlignment = Alignment.center,
    this.disableBodyAlignment = false,
  });

  final Widget header;
  final Widget body;
  Widget? footer;
  double? horPadding;
  bool showCloseIcon;
  double? height;
  double? width;
  bool makeHeightDynamic;
  Alignment bodyAlignment;
  bool disableBodyAlignment;

  @override
  Widget build(BuildContext context) {
    return ResponsiveFrameworkService().globalResponsive(
      context,
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          // margin: EdgeInsets.symmetric(vertical: 8),
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: ScreenUtils.viewInsetsBottom(context)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  DesignMetrics().dialogRadius,
                ),
                color: AppColors().getDialogBackgroundColor,
              ),
              height: makeHeightDynamic
                  ? null
                  : height ?? DesignMetrics().dialogHeight,
              width: width ?? DesignMetrics().dialogWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: DesignMetrics().dialogPaddingVer,
                      bottom: DesignMetrics().dialogPaddingVer,
                      left: horPadding ?? DesignMetrics().dialogPaddingHor,
                      right: horPadding ?? DesignMetrics().dialogPaddingHor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        header,
                        SizedBox(
                          height: DesignMetrics().dialogTitleBodyGap,
                        ),
                        makeHeightDynamic
                            ? Flexible(child: body)
                            : Expanded(
                                child: Container(
                                    alignment: disableBodyAlignment
                                        ? null
                                        : bodyAlignment,
                                    child: body)),
                        if (footer != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: DesignMetrics().dialogBodyFooterGap,
                              ),
                              footer!,
                            ],
                          ),
                      ],
                    ),
                  ),
                  if (showCloseIcon)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          onPressed: () {
                            RouteService().pop();
                          },
                          icon: Icon(
                            shadows: [
                              BoxShadow(
                                  color: AppColors().getIconColor,
                                  blurRadius: 3,
                                  blurStyle: BlurStyle.outer,
                                  spreadRadius: 10)
                            ],
                            Icons.close,
                            weight: 100,
                            grade: 100,
                            opticalSize: 100,
                            color: AppColors().getIconColor,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

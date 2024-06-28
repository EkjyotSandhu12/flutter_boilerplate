import 'package:flutter/material.dart';

import '../../../route/go_router/route_service.dart';
import '../../../services/reponsive_framework_service.dart';
import '../../../theme/app_colors.dart';
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



  double get dialogTitleBodyGap => 12;
  double get dialogBodyFooterGap => 12;
  double get dialogPaddingVer => 22;
  double get dialogPaddingHor => 22;
  double get dialogHeight => 330;
  double get dialogWidth => 300;
  double get commonContainerRadius12 => (12);
  double get dialogRadius => (12);


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
                  dialogRadius,
                ),
                color: AppColors().getPrimaryColor,
              ),
              height: makeHeightDynamic
                  ? null
                  : height ??dialogHeight,
              width: width ?? dialogWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: dialogPaddingVer,
                      bottom:dialogPaddingVer,
                      left: horPadding ??dialogPaddingHor,
                      right: horPadding ??dialogPaddingHor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        header,
                        SizedBox(
                          height: dialogTitleBodyGap,
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
                                height: dialogBodyFooterGap,
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
                                  color: AppColors().getPrimaryColor,
                                  blurRadius: 3,
                                  blurStyle: BlurStyle.outer,
                                  spreadRadius: 10)
                            ],
                            Icons.close,
                            weight: 100,
                            grade: 100,
                            opticalSize: 100,
                            color: AppColors().getPrimaryColor,
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

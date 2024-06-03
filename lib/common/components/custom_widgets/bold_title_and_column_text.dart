import 'package:flutter/material.dart';

class BoldTitleAndColumnText extends StatelessWidget {
  BoldTitleAndColumnText({
    super.key,
    required this.title,
    required this.eachLine,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.titleStyle,
    this.bodyTextsStyle,
    this.gapBetweenEachLine,
    this.gapBetweenTitleColumn = 0,
  });

  final String title;
  final List<String> eachLine;
  TextStyle? titleStyle;
  TextStyle? bodyTextsStyle;
  CrossAxisAlignment? crossAxisAlignment;
  MainAxisAlignment? mainAxisAlignment;
  double? gapBetweenEachLine;
  double gapBetweenTitleColumn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          title,
/*          style: titleStyle ??
              TextStyles().getF15TextStyle(
                fontWeight: FontWeight.w600,
              ),*/
        ),
        SizedBox(
          height: gapBetweenTitleColumn,
        ),
        ...eachLine.map((e) {
          bool isLast = eachLine.indexOf(e) == eachLine.length - 1;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                e,
                style: bodyTextsStyle,
                textAlign: TextAlign.center,
              ),
              if (!isLast)
                SizedBox(
                  height: gapBetweenEachLine,
                ),
            ],
          );
        }).toList()
      ],
    );
  }
}

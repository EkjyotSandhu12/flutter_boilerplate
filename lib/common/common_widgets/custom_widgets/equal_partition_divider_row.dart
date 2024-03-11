import 'package:flutter/material.dart';

class CustomWidth {
  int indexToModify;
  double width;

  CustomWidth({required this.indexToModify, required this.width});
}

class EqualPartitionDividerInRow extends StatelessWidget {
  EqualPartitionDividerInRow({
    super.key,
    required this.rowWidgets,
    this.containerAlignment,
    this.gapBetweenTileColumn = 12,
    this.customWidths,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding = EdgeInsets.zero,
  });

  final List<Widget> rowWidgets;
  List<CustomWidth>? customWidths; //change width of specific indexed widget
  AlignmentGeometry? containerAlignment;
  double gapBetweenTileColumn;
  CrossAxisAlignment crossAxisAlignment;
  EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      List<Widget> widgets = [];

      for (var w in rowWidgets) {
        bool hasCustomWidth = false;

        bool isLast = rowWidgets.indexOf(w) == rowWidgets.length - 1;
        int currentIndex = rowWidgets.indexOf(w);

        if (customWidths != null) {
          for (var element in customWidths!) {
            if (element.indexToModify == currentIndex) {
              hasCustomWidth = true;
              break;
            }
          }
        }

        w = Container(
          alignment: containerAlignment ?? Alignment.center,
          child: w,
        );

        if (hasCustomWidth) {
          widgets.add(
            SizedBox(
              width: customWidths!
                  .firstWhere(
                      (element) => element.indexToModify == currentIndex)
                  .width,
              child: w,
            ),
          );
        } else {
          widgets.add(Expanded(
            child: w,
          ));
        }

        if (!isLast) {
          widgets.add(SizedBox(
            width: gapBetweenTileColumn,
          ));
        }
      }

      return Container(
        padding:padding,
        width: constraints.maxWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            ...widgets,
          ],
        ),
      );
    });
  }
}

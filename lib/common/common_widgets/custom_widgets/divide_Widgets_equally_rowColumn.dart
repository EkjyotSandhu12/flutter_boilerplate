import 'package:flutter/material.dart';
import 'equal_partition_divider_row.dart';

class CustomGap {
  int indexNo;

  double gap;

  CustomGap({required this.indexNo, required this.gap});
}

//EXAMPLE
//[w1,w2]
//[w3,w4]
//[w5]
//it will take infinite width and divide equally according to available width
class EqualWidgetDividerByRowColumn extends StatelessWidget {
  EqualWidgetDividerByRowColumn({
    super.key,
    required this.widgets,
    this.gapBetweenRow = 0,
    this.gapBetweenColumn,
    this.totalColumns = 2,
    this.containerAlignment = Alignment.center,
    this.eachRowCrossAxisAlignment,
    this.customGaps,
  });

  final List<Widget> widgets;
  Alignment containerAlignment;
  int totalColumns;
  double gapBetweenRow;
  double? gapBetweenColumn;
  CrossAxisAlignment? eachRowCrossAxisAlignment;
  List<CustomGap>? customGaps = [];
  List<Widget> rows = [];

  divideWidgetsInColumnAndRows() {
    int totalRows = widgets.length ~/ totalColumns;
    int selectedWidget = 0;

    for (int i = 0; i <= totalRows && selectedWidget < widgets.length; i++) {
      List<Widget> row = [];

      for (int j = 0; j < totalColumns; j++) {
        if (selectedWidget < widgets.length) {
          row.add(widgets[selectedWidget]);
        } else {
          row.add(const SizedBox());
        }
        selectedWidget++;
      }

      bool isLastRow = i == totalRows - 1 + (widgets.length % totalColumns);

      Widget widget = Container(
        // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: Padding(
          padding: !isLastRow
              ? EdgeInsets.only(
                  bottom: customGaps != null
                      ? customGaps!
                          .firstWhere(
                            (e) => e.indexNo == i,
                            orElse: () =>
                                CustomGap(indexNo: 0, gap: gapBetweenRow),
                          )
                          .gap
                      : gapBetweenRow)
              : EdgeInsets.zero,
          child: EqualPartitionDividerInRow(
            crossAxisAlignment:
                eachRowCrossAxisAlignment ?? CrossAxisAlignment.center,
            gapBetweenTileColumn:
                gapBetweenColumn??12,
            containerAlignment: containerAlignment,
            rowWidgets: row,
          ),
        ),
      );
      rows.add(widget);
    }
  }

  @override
  Widget build(BuildContext context) {
    divideWidgetsInColumnAndRows();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...rows,
      ],
    );
  }
}

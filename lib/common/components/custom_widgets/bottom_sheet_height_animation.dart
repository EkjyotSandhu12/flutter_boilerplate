import 'package:flutter/material.dart';

import '../../Utils/utils.dart';
import '../../theme/theme_constants.dart';

///==> BOTTOM SHEETS CUTOMIZATIONS


//Usage Example
//A page controller that will be assigned to BottomSheetHeightAnimation() widget.
//Are the height of content of BottomSheetHeightAnimation changes, the bottom sheet height will also change.

/*
  showCreateSessionBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      context: Utils.getCtx(),
      useSafeArea: true,
      builder: (context) => BottomSheetHeightAnimation(),
      isDismissible: false,
    );
  }*/

/*    return BottomSheetHeightAnimation(
      pageController: sessionCreationProvider.pageController,
      pages: [
        Container(
          child: EnterSessionNameUI(
            onCreateSessionClick: ({required sessionName}) {
              sessionCreationProvider.onCreateSessionClick(sessionName);
              sessionCreationProvider.pageController.nextPage(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.decelerate);
            },
          ),
        ),
        const EditOrAddWorkouts(),
        if (sessionCreationProvider.selectedAddType != null)
          currentSelectedAddType()
      ],
      pagesHeights: [
        230,
        Utils.getScreenHeight(removeViewPadding: true),
        Utils.getScreenHeight(removeViewPadding: true),
        Utils.getScreenHeight(removeViewPadding: true),
        Utils.getScreenHeight(removeViewPadding: true),
      ],
    );*/



class BottomSheetHeightAnimation extends StatefulWidget {
  BottomSheetHeightAnimation(
      {super.key,
      required this.pagesHeights,
      required this.pages,
      this.pageController});

  final List<double> pagesHeights;
  final List<Widget> pages;
  PageController? pageController = PageController();

  @override
  State<BottomSheetHeightAnimation> createState() =>
      _BottomSheetHeightAnimationState();
}

class _BottomSheetHeightAnimationState
    extends State<BottomSheetHeightAnimation> {
  late PageController pageController;

  double bottomSheetHeight = 0;
  int currentActivePage = 0;
  int movingToPage = 0;

  //Height Animation Logic Variables

  @override
  void initState() {
    pageController = widget.pageController!;
    bottomSheetHeight = widget.pagesHeights[0];

    pageController.addListener(() {
      int swipePercentage =
          getNumberAfterDecimalPoint(number: pageController.page ?? 0);
      if (swipePercentage > 80 || swipePercentage < 20) {
        //we have completely travelled to new page, only then update current page
        currentActivePage = (pageController.page ?? 0).toInt();
      }

      if (swipePercentage != 0) {
        movingToPage = currentActivePage < (pageController.page!)
            ? currentActivePage + 1
            : currentActivePage - 1;
      } else {
        movingToPage = currentActivePage;
      }

      double nextPageHeight = widget.pagesHeights[movingToPage];
      double currentPageHeight = widget.pagesHeights[currentActivePage];
      double differenceInHeight = (nextPageHeight - currentPageHeight);

      bottomSheetHeight =
          currentPageHeight + (differenceInHeight * (swipePercentage / 100));

      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bottomSheetHeight,
      child: PageView(
        // physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (value) {
          //value is changed at 50% position
          //movingToPage = value;
        },
        children: [
          ...widget.pages.map((e) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: e,
              ))
        ],
      ),
    );
  }

  static int getNumberAfterDecimalPoint(
      {required double number, int lengthOfDecimalPoint = 2}) {
    // Method 1: Using toString() and split()
    String numberAsString = number.toString();
    List<String> splitNumber = numberAsString.split('.');

    // Method 2: Using toStringAsFixed() and substring()
    int? decimalPointNumber = int.tryParse(splitNumber[1].substring(
        0,
        splitNumber[1].toString().length >= lengthOfDecimalPoint
            ? lengthOfDecimalPoint
            : splitNumber[1].length));
/*    log.infoLog(
      "getNumberAfterDecimalPoint ==> $decimalPointNumber",
    );*/
    return decimalPointNumber ?? 0;
  }
}

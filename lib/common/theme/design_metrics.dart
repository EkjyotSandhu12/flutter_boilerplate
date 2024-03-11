import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/screen_properties_service.dart';

//This will contain all sizes, used in entire app, to make the app consistent and use same sizes all over the app
//FONT SIZES
//WIDTHS/HEIGHTS
//PADDING AND MARGINS

class DesignMetrics {
  ///==> MARGINS/PADDING/HEIGHT/WIDTH DECLARE
  double _margin4 = 4;
  double _margin6 = 6;

  ///
  double _padding10 = 10;
  double _padding15 = 15;

  ///
  double _height60 = 60;
  double _height78 = 78;

  ///
  double _width170 = 170;
  double _width105 = 105;

  ///
  double _radius30 = 30;
  double _radius10 = 10;

  ///

  ///==> GETTERS
  //==> APP MARGINS GETTER
  double get titleAndTxtFieldGap => _updateBasedOnScreenWidth(_margin6);
  double get marginGapBetweenInputTextFieldVer => _updateBasedOnScreenWidth(_margin6); //used when there are multiple text-fields
  //==> APP PADDINGS GETTER
  double get entireAppPaddingTop => _updateBasedOnScreenWidth(_padding10);
  double get entireAppPaddingBottom => _updateBasedOnScreenWidth(_padding10);

  //==> APP HEIGHTS GETTER
  double get bottomNavHeight => _updateBasedOnScreenWidth(_height60);
  double get appCommonHeaderHeight => _updateBasedOnScreenWidth(_height60);

  //==> APP WIDTHS GETTER
  double get buttonWidthBelowList => _updateBasedOnScreenWidth(_width170); //most common button width used through out the app.
  double get dialogButtonWidth =>  _updateBasedOnScreenWidth(_width105); //most common button width used through out the app.
  //==> APP RADIUS GETTER
  double get imageHolderContainerRadius => _updateBasedOnScreenWidth(_radius30);
  BorderRadius get dialogRadius => BorderRadius.circular(_updateBasedOnScreenWidth(_radius30));

  ///==================================================///
  _updateBasedOnScreenWidth(double moreThan400,{
    double? moreThan800,
    double? moreThan1280,
    double? moreThan1600,
  }) {
    ScreenPropertiesService screenPropertiesService = ScreenPropertiesService();

    switch (screenPropertiesService.screenWidth) {
      case > 400:
        return moreThan400;
      case > 800:
        return moreThan800 ?? moreThan400;
      case > 1280:
        return moreThan1280 ?? moreThan400;
      case > 1600:
        return moreThan1600 ?? moreThan400;
      default:
        return moreThan400;
    }
  }
}

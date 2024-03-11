import '../services/screen_properties_service.dart';

import '../theme/theme_constants.dart';


//the difference between current screen height or width and designScreenHeight or designScreenWidth, will be subtracted or added into the values passed by parameters

dHeight(double height) {
  return (ScreenPropertiesService().screenHeight /
          ThemeConstants.designScreenHeight) *
      height;
}

dWidth(double width) {
  return (ScreenPropertiesService().screenWidth /
          ThemeConstants.designScreenWidth) *
      width;
}

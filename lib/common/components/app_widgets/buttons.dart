import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class BtnProperties {
  Size? size;
  double? textSize;

  BtnProperties({
    this.size,
    this.textSize,
  });
}

class BtnElevated extends StatelessWidget {
  BtnElevated({super.key, this.btnProperties, required this.onTap, required this.buttonText});

  final String buttonText;
  BtnProperties? btnProperties;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ElevatedButton.styleFrom(
        minimumSize:btnProperties?.size,
        fixedSize: btnProperties?.size,
        backgroundColor: AppColors().getButtonBackgroundColor,
      ),
      child: Text(
       buttonText ,
        style: TextStyle(fontSize: btnProperties?.textSize, color: AppColors().getButtonTextColour),
      ),

    );
  }
}

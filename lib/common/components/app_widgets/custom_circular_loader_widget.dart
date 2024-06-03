import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';


class CustomCircularLoaderWidget extends StatelessWidget {
  const CustomCircularLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: AppColors().getLoaderColor,
    );
  }
}

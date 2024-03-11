import 'package:flutter/material.dart';
import 'common/theme/app_colors.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'common/helpers/initializer.dart';
import 'common/route/router.dart';
import 'common/services/screen_properties_service.dart';

main() {
  Initializer.init(() {
    runApp(const InitMaterialApp());
  },);
}

class InitMaterialApp extends StatelessWidget {
  const InitMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenPropertiesService().updateScreenProperties(MediaQuery.of(context));
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: ValueListenableBuilder(
            valueListenable: AppColors().isDarkTheme,
            builder: (BuildContext context, bool value, Widget? c) =>
                child!,
          ),
        ),
        breakpoints: [],
      ),
      routerConfig: appRouter.config(),
    );
  }
}

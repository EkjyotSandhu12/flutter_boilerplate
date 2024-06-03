import 'package:flutter/material.dart';

//wrapper to get a global control over multiple widgets in order to update them or make changes in all of them at the same time.


class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

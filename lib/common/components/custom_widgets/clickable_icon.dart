import 'package:flutter/material.dart';

class ClickableIcon extends StatelessWidget {
  const ClickableIcon(
      {super.key,
      required this.child,
      required this.onTap,
      this.splashPadding = const EdgeInsets.all(8.0)});

  final Widget child;
  final VoidCallback onTap;
  final EdgeInsets splashPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: splashPadding,
          child: child,
        ),
      ),
    );
  }
}

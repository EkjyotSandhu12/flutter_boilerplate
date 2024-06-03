import 'package:flutter/material.dart';
import '../../../theme/text_styles.dart';
import '../../../theme/theme_decorations.dart';

enum SnackBarType {
  warning(Icon(
    Icons.error,
    color: Colors.yellow,
    size: 26,
  )),
  error(Icon(
    Icons.error,
    color: Colors.red,
    size: 26,
  )),
  info(Icon(
    Icons.info_rounded,
    color: Colors.blue,
    size: 26,
  )),
  success(Icon(
  Icons.check_circle_rounded,
  color: Colors.green,
  size: 26,
  ));

  const SnackBarType(this.icon);

  final Widget icon;
}

class SnackBarUI extends StatelessWidget {
  const SnackBarUI({super.key, required this.snackBarType, required this.text});

  final SnackBarType snackBarType;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          color: Colors.white,
          boxShadow: [ThemeDecorations().commonContainerBoxShadow()]),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
      width: double.infinity,
      child: Row(
        children: [
          snackBarType.icon,
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              text,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
              size: 26,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          ),
        ],
      ),
    );
  }
}

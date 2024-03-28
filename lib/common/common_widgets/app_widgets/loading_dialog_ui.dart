import 'package:flutter/material.dart';
import 'custom_circular_loader_widget.dart';
import 'dialogs/common_dialog_ui.dart';

class LoadingDialogUI extends StatelessWidget {
  const LoadingDialogUI({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return CommonDialogUI(
        height: 140,
        width: 240,
        header: Text(
          text,
        ),
        body: CustomCircularLoaderWidget());
  }
}

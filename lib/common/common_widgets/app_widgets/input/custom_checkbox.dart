import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme_decorations.dart';

class CustomCheckBox extends StatefulWidget {
  CustomCheckBox({
    super.key,
    required this.onChange,
    this.checkBoxScale = 1,
    this.rightGap = 10,
    this.height = 30,
    this.width = 20,
    this.border,
    this.enabled = true,
    this.initialValue = false,
  });

  final Function(bool) onChange;
  double checkBoxScale;
  double rightGap;
  double height;
  double width;
  BorderSide? border;
  bool enabled;
  bool initialValue;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool value = false;

  @override
  void initState() {
    value = widget.initialValue ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: widget.rightGap),
      child: Container(
        decoration: BoxDecoration(),
        width: widget.width,
        height: widget.height,
        child: Transform.scale(
          scale: 1 * widget.checkBoxScale,
          child: Checkbox(
            value: value,
            onChanged: !widget.enabled
                ? null
                : (v) {
                    setState(() {
                      value = !value;
                    });
                    widget.onChange(
                      value,
                    );
                  },
            activeColor: AppColors().primaryColor,
            checkColor: Colors.white,
            side: widget.border,
          ),
        ),
      ),
    );
  }
}

class CustomCheckBoxShadow extends StatefulWidget {
  const CustomCheckBoxShadow({super.key, required this.onChange});

  final Function(bool) onChange;

  @override
  State<CustomCheckBoxShadow> createState() => _CustomCheckBoxShadowState();
}

class _CustomCheckBoxShadowState extends State<CustomCheckBoxShadow> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [ThemeDecorations().commonContainerBoxShadow()],
        ),
        height: 14,
        width: 14,
        child: Checkbox(
          value: value,
          onChanged: (v) {
            setState(() {
              value = !value;
            });
            widget.onChange(value);
          },
          activeColor: Colors.transparent,
          checkColor: AppColors().primaryColor,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SVGImage extends StatelessWidget {
  SVGImage({
    Key? key,
    this.size = 30,
    this.color,
    this.fit = BoxFit.scaleDown,
  }) : super(key: key);
  double size;
  Color? color;
  BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      '',
      height: size,
      width: size,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      fit: fit,
    );
  }
}

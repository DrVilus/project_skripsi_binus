import 'package:flutter/material.dart';
import 'Palette.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius}) : super(key: key);

  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return
      ClipRRect(
          child: Container(
            child: child,
            margin: margin ?? const EdgeInsets.only(top: 20),
            padding: padding ?? const EdgeInsets.only(left: 10, right: 10),
            width: width,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              color: Palette.widgetBackground1,
              borderRadius: borderRadius ?? const BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          )
      );
  }
}

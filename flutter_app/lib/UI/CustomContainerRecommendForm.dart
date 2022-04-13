import 'package:flutter/material.dart';
import 'Palette.dart';

class CustomContainerRecommendForm extends StatelessWidget {
  const CustomContainerRecommendForm(
      {Key? key, this.child, this.width, this.height})
      : super(key: key);
  final Widget? child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        child: Container(
      child: child,
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: width ?? MediaQuery.of(context).size.width * 0.8,
      height: height ?? MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
        color: Palette.widgetBackground1,
        // ignore: prefer_const_constructors
        borderRadius: BorderRadius.only(
          bottomRight: const Radius.circular(20),
          topRight: const Radius.circular(20),
          topLeft: const Radius.circular(20),
          bottomLeft: const Radius.circular(20),
        ),
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'Palette.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({Key? key, this.child, this.width, this.height}) : super(key: key);
  final Widget? child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return
      ClipRRect(
          child: Container(
            child: child,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.only(left: 10, right: 10),
            width: width ?? MediaQuery.of(context).size.width * 0.8,
            height: height ?? MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              color: Palette.widgetBackground1,
              borderRadius: BorderRadius.only(
                bottomRight: const Radius.circular(10),
                topRight: const Radius.circular(10),
                topLeft: const Radius.circular(10),
                bottomLeft: const Radius.circular(10),
              ),
            ),
          )
      );
  }
}

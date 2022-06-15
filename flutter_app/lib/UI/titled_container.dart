import 'package:flutter/material.dart';

import 'palette.dart';

class TitledContainer extends StatelessWidget {
  const TitledContainer(
      {Key? key,
      this.child,
      this.withBottomRightBorder = false,
      this.title,
      this.width,
      this.height})
      : super(key: key);
  final Widget? child;
  final bool withBottomRightBorder;
  final String? title;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    Radius bottomRightRadius;
    if (withBottomRightBorder == true) {
      bottomRightRadius = const Radius.circular(40);
    } else {
      bottomRightRadius = const Radius.circular(10);
    }
    return Stack(
      children: [
        ClipRRect(
            child: Container(
          child: child,
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          width: width ?? MediaQuery.of(context).size.width * 0.8,
          height: height ?? MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            color: Palette.widgetBackground1,
            borderRadius: BorderRadius.only(
              bottomRight: bottomRightRadius,
              topRight: const Radius.circular(10),
              topLeft: const Radius.circular(10),
              bottomLeft: const Radius.circular(10),
            ),
          ),
        )),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.25,
          child: Container(
            child: Text(title ?? "", style: TextStyles.interStyle1),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: Palette.widgetBackground1,
                borderRadius: BorderRadius.circular(10)),
          ),
        )
      ],
    );
  }
}

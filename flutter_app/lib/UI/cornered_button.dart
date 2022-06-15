import 'package:flutter/material.dart';

import 'palette.dart';

class CorneredButton extends StatelessWidget {
  const CorneredButton({Key? key, required this.child, required this.onPressed})
      : super(key: key);
  final Widget child;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: child,
      style: ElevatedButton.styleFrom(
        primary: Palette.widgetBackground1,
        side: const BorderSide(width: 2, color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30),
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
      ),
    );
  }
}

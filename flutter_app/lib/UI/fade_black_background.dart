import 'package:flutter/cupertino.dart';

class FadeBlackBackground extends StatelessWidget {
  const FadeBlackBackground({
    Key? key,
    required bool toggleVariable,
  }) : isMenuButtonPressed = toggleVariable, super(key: key);

  final bool isMenuButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isMenuButtonPressed,
        child: Container(
          color: const Color(0xFF000000).withOpacity(0.5),
        )
    );
  }
}
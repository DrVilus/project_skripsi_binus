import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Palette {
  // background gradient
  static Color mainBackground = const Color(0xff353030);
  static Color widgetBackground1 = const Color(0xff1E1E1E);
  static Color grey = const Color(0xffC4C4C4);
}

class TextStyles {
  static var interStyle1 = GoogleFonts.inter(color: Colors.white);
  static var sourceSans3 =
      GoogleFonts.sourceSans3(color: Colors.white, fontSize: 18);
  static var interStyleBuildGuidePageButton =
      GoogleFonts.inter(color: Colors.white, fontSize: 25);
  static var interStyleBuildGuidePageTitle = GoogleFonts.inter(
      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
  static var interStyleBuildGuidePageDescription =
      GoogleFonts.sourceSans3(color: Colors.white, fontSize: 20);
  static var sourceSans3partsSelectWidgetPartName =
    GoogleFonts.sourceSans3(color: Colors.white, fontSize: 15);
}

import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../UI/Palette.dart';

//Bukan page, dijadikan widget dan di-toggle melalui CustomAppbar
class ChoosePartsWidget extends StatefulWidget {
  const ChoosePartsWidget({Key? key, required this.toggleSideBar}) : super(key: key);
  final Function toggleSideBar;

  @override
  State<ChoosePartsWidget> createState() => _ChoosePartsWidgetState();
}

class _ChoosePartsWidgetState extends State<ChoosePartsWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width*0.95, (MediaQuery.of(context).size.width*0.95*1.446629213483146).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: WidgetBackgroundPainter(),
            ),
            Positioned(
              right: 50,
              top: 50,
              child: CustomPaint(
                size: Size(2, MediaQuery.of(context).size.height *0.55), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: LinePainter(),
              ),
            ),
            Positioned(
              right: 10,
              top: MediaQuery.of(context).size.height*0.3,
              child: CustomPaint(
                size: Size(16, 27), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: ArrowPainter(),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                color: Colors.white.withOpacity(0.5),
                width: MediaQuery.of(context).size.width*0.82,
                height: (MediaQuery.of(context).size.width*0.95*1.446629213483146).toDouble(),
                child: Text("Fuck", style: TextStyles.interStyle1,),
              ),
            ),
            Positioned(
              right: 0,
              top: 10,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  widget.toggleSideBar();
                },
                child: Container(
                  width: 50,
                  height: MediaQuery.of(context).size.height *0.7,
                  //color: Colors.yellow.shade600,
                ),
              ),
            )
          ],
        )
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class WidgetBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.9053371,size.height*0.01087961);
    path_0.lineTo(size.width*0.9786489,size.height*0.05452311);
    path_0.cubicTo(size.width*0.9904213,size.height*0.06153165,size.width*0.9971910,size.height*0.07173845,size.width*0.9971910,size.height*0.08247845);
    path_0.lineTo(size.width*0.9971910,size.height*0.7348913);
    path_0.cubicTo(size.width*0.9971910,size.height*0.7427146,size.width*0.9935955,size.height*0.7503340,size.width*0.9869213,size.height*0.7566505);
    path_0.lineTo(size.width*0.8999073,size.height*0.8390078);
    path_0.cubicTo(size.width*0.8925309,size.height*0.8459903,size.width*0.8885562,size.height*0.8544117,size.width*0.8885562,size.height*0.8630583);
    path_0.lineTo(size.width*0.8885562,size.height*0.9611650);
    path_0.cubicTo(size.width*0.8885562,size.height*0.9815398,size.width*0.8646601,size.height*0.9980583,size.width*0.8351854,size.height*0.9980583);
    path_0.lineTo(size.width*0.002808989,size.height*0.9980583);
    path_0.lineTo(size.width*0.002808989,size.height*0.001941748);
    path_0.lineTo(size.width*0.8705084,size.height*0.001941748);
    path_0.cubicTo(size.width*0.8832921,size.height*0.001941748,size.width*0.8956489,size.height*0.005113301,size.width*0.9053371,size.height*0.01087961);
    path_0.close();

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.005617978;
    paint_0_stroke.color=Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_stroke);

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = Palette.widgetBackground1;
    canvas.drawPath(path_0,paint_0_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width;
    paint_0_stroke.color=Colors.white.withOpacity(1.0);
    canvas.drawLine(Offset(size.width*0.5000000,size.height*1.300935e-10),Offset(size.width*0.4999925,size.height),paint_0_stroke);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(15,26);
    path_0.lineTo(2,13.5);
    path_0.lineTo(15,1);

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.1250000;
    paint_0_stroke.color=Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_stroke);

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = Palette.widgetBackground1;
    canvas.drawPath(path_0,paint_0_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
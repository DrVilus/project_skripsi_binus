import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Palette.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({Key? key, this.title, this.sideBarOpacity = 1.0}) : super(key: key);

  final String? title;
  final double sideBarOpacity;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width,(MediaQuery.of(context).size.width*0.25).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                    painter: CustomClipperAppbar(),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width*0.25,
                      child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          widget.title ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18),
                          softWrap: true,
                        ),
                      ],
                    ),
                    ),
                  ),
                ],
              ),
            )
        ),
        Positioned(
          child: Opacity(
            opacity: widget.sideBarOpacity,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width,(MediaQuery.of(context).size.width*1.22).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: CustomPainterSidebar(),
            ),
          )
        ),
        Positioned(
          top: -25,
          left: -30,
          child: ElevatedButton(
            child: const Icon(
              Icons.list,
              color: Colors.white,
              size: 60,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 150),
                shape: const CircleBorder(),
                primary: Palette.widgetBackground1,
                side: const BorderSide(width: 2.5, color: Colors.white)

            ),
          ),
        ),

      ],
    );
  }
}

class CustomClipperAppbar extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;


    Path path0 = Path();
    path0.moveTo(0,0);
    path0.lineTo(0,size.height*0.7500000);
    path0.lineTo(size.width*0.7349500,size.height*0.7500000);
    path0.quadraticBezierTo(size.width*0.7485125,size.height*0.7518000,size.width*0.7550625,size.height*0.7260000);
    path0.quadraticBezierTo(size.width*0.7624500,size.height*0.7044000,size.width*0.7656000,size.height*0.6890000);
    path0.lineTo(size.width*0.8054750,size.height*0.5262000);
    path0.quadraticBezierTo(size.width*0.8090750,size.height*0.5101000,size.width*0.8103750,size.height*0.4909500);
    path0.quadraticBezierTo(size.width*0.8124125,size.height*0.4754000,size.width*0.8121750,size.height*0.4498000);
    path0.lineTo(size.width*0.8125000,size.height*0.0800000);
    path0.quadraticBezierTo(size.width*0.8128000,size.height*0.0314500,size.width*0.8078125,size.height*0.0101000);
    path0.quadraticBezierTo(size.width*0.8025125,size.height*-0.0021000,size.width*0.7862500,0);
    path0.quadraticBezierTo(size.width*0.5896875,0,0,0);
    path0.close();

    canvas.drawPath(path0, paint0);


    Paint paint1 = Paint()
      ..color = Palette.widgetBackground1
      ..style = PaintingStyle.fill
      ..strokeWidth = 6;


    Path path1 = Path();
    path1.moveTo(0,0);
    path1.lineTo(0,size.height*0.7500000);
    path1.lineTo(size.width*0.7349500,size.height*0.7500000);
    path1.quadraticBezierTo(size.width*0.7485125,size.height*0.7518000,size.width*0.7550625,size.height*0.7260000);
    path1.quadraticBezierTo(size.width*0.7624500,size.height*0.7044000,size.width*0.7656000,size.height*0.6890000);
    path1.lineTo(size.width*0.8054750,size.height*0.5262000);
    path1.quadraticBezierTo(size.width*0.8090750,size.height*0.5101000,size.width*0.8103750,size.height*0.4909500);
    path1.quadraticBezierTo(size.width*0.8124125,size.height*0.4754000,size.width*0.8121750,size.height*0.4498000);
    path1.lineTo(size.width*0.8125000,size.height*0.0800000);
    path1.quadraticBezierTo(size.width*0.8128000,size.height*0.0314500,size.width*0.8078125,size.height*0.0101000);
    path1.quadraticBezierTo(size.width*0.8025125,size.height*-0.0021000,size.width*0.7862500,0);
    path1.quadraticBezierTo(size.width*0.5896875,0,0,0);
    path1.close();

    canvas.drawPath(path1, paint1);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
class CustomPainterSidebar extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;


    Path path0 = Path();
    path0.moveTo(0,0);
    path0.lineTo(0,size.height*0.8032787);
    path0.quadraticBezierTo(size.width*-0.0015667,size.height*0.8243955,size.width*0.0091833,size.height*0.8284631);
    path0.cubicTo(size.width*0.0195167,size.height*0.8332787,size.width*0.0350500,size.height*0.8327459,size.width*0.0457833,size.height*0.8282684);
    path0.quadraticBezierTo(size.width*0.0545333,size.height*0.8247746,size.width*0.0766667,size.height*0.8094262);
    path0.lineTo(size.width*0.1073000,size.height*0.7891393);
    path0.quadraticBezierTo(size.width*0.1335333,size.height*0.7716496,size.width*0.1335500,size.height*0.7657787);
    path0.quadraticBezierTo(size.width*0.1334833,size.height*0.7427561,size.width*0.1333333,size.height*0.7167623);
    path0.lineTo(size.width*0.1333333,0);
    path0.lineTo(0,0);
    path0.close();

    canvas.drawPath(path0, paint0);


    Paint paint1 = Paint()
      ..color = Palette.widgetBackground1
      ..style = PaintingStyle.fill
      ..strokeWidth = 6;


    Path path1 = Path();
    path1.moveTo(0,0);
    path1.lineTo(0,size.height*0.8032787);
    path1.quadraticBezierTo(size.width*-0.0015667,size.height*0.8243955,size.width*0.0091833,size.height*0.8284631);
    path1.cubicTo(size.width*0.0195167,size.height*0.8332787,size.width*0.0350500,size.height*0.8327459,size.width*0.0457833,size.height*0.8282684);
    path1.quadraticBezierTo(size.width*0.0545333,size.height*0.8247746,size.width*0.0766667,size.height*0.8094262);
    path1.lineTo(size.width*0.1189000,size.height*0.7806557);
    path1.quadraticBezierTo(size.width*0.1341500,size.height*0.7708709,size.width*0.1333333,size.height*0.7630943);
    path1.quadraticBezierTo(size.width*0.1333333,size.height*0.7540471,size.width*0.1333333,size.height*0.7479508);
    path1.lineTo(size.width*0.1333333,0);
    path1.lineTo(0,0);
    path1.close();

    canvas.drawPath(path1, paint1);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

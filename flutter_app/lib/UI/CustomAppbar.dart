import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_skripsi/Pages/BuildGuide/BuildGuidePage.dart';
import 'package:project_skripsi/Pages/BuildSchema/ChoosePartsWidget.dart';
import 'package:project_skripsi/UI/CustomContainer.dart';
import 'package:project_skripsi/Variables/GlobalVariables.dart';
import 'package:touchable/touchable.dart';

import 'FadeBlackBackground.dart';
import 'Palette.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({Key? key, this.title, this.sideBarVisible = true, required this.children}) : super(key: key);

  final String? title;
  final bool sideBarVisible;
  final List<Widget> children;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  bool _isMenuButtonPressed = false;
  bool _isSideBarPressed = false;
  void _toggleMenu() {
    setState(() {
      _isMenuButtonPressed = !_isMenuButtonPressed;
    });
  }

  void _toggleSideBar(){
    setState(() {
      _isSideBarPressed = !_isSideBarPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width,(MediaQuery.of(context).size.width*0.1806853582554517).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
            painter: CustomPainterAppbar(),
            child: SizedBox(
                width: MediaQuery.of(context).size.width*0.8,
                height: MediaQuery.of(context).size.height*0.1,
                child: Padding(
                  padding:  EdgeInsets.only(
                      top: 16,
                      left: MediaQuery.of(context).size.width*0.2
                  ),
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
                )
            ),
          ),
        ),
        Visibility(
            visible: widget.sideBarVisible,
            child: AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: _isSideBarPressed ? -50 : 0,
              child: CanvasTouchDetector(
                gesturesToOverride: const [GestureType.onTapDown],
                builder: (context) => CustomPaint(
                  size: Size(50,(50*9.279069767441861).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: CustomPainterSidebar(context, () => _toggleSideBar()),
                ),
              ),
            )
        ),
        ...widget.children,
        FadeBlackBackground(toggleVariable: _isMenuButtonPressed),
        FadeBlackBackground(toggleVariable: _isSideBarPressed),
        Visibility(
          visible: _isMenuButtonPressed,
          child: Positioned(
              top: 40,
              child: CustomContainer(
                width: 250,
                height: 400,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                                child: SizedBox(), flex: 1),
                            Expanded(
                                child: Center(
                                  child: Text("Menu", style: TextStyles.interStyle1),
                                ),
                                flex: 2
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                        height: 1,
                        thickness: 2,
                        color: Colors.white
                    ),
                    Expanded(
                        child: MenuButton(
                          onPressed: () {
                            _toggleMenu();
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                  (context, animation1, animation2) =>
                                    const BuildGuidePage(),
                                      transitionDuration: Duration.zero,
                              ),
                            );
                          },
                          iconData: Icons.text_snippet,
                          text: 'Build Guide',
                        )
                    ),
                    const Divider(
                        height: 1,
                        thickness: 2,
                        color: Colors.white
                    ),
                    Expanded(
                        child: MenuButton(
                          onPressed: () {},
                          iconData: Icons.file_download,
                          text: 'Import Build',
                        )
                    ),
                    const Divider(
                        height: 1,
                        thickness: 2,
                        color: Colors.white
                    ),
                    Expanded(
                        child: MenuButton(
                          onPressed: () {},
                          iconData: Icons.file_upload,
                          text: 'Export Build',
                        )
                    ),
                    const Divider(
                        height: 1,
                        thickness: 2,
                        color: Colors.white
                    ),
                    Expanded(
                        child: MenuButton(
                          onPressed: () {},
                          iconData: Icons.settings,
                          text: 'Settings',
                        )
                    ),
                    const Divider(
                        height: 1,
                        thickness: 2,
                        color: Colors.white
                    ),
                    Expanded(
                        child: MenuButton(
                          onPressed: () {},
                          iconData: Icons.help_outline,
                          text: 'Help',
                          inkwellBorderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)
                          ),
                        )
                    )
                  ],
                ),
              )
          ),
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
            onPressed: () {
              _toggleMenu();
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 150),
                shape: const CircleBorder(),
                primary: Palette.widgetBackground1,
                side: const BorderSide(width: 2, color: Colors.white)
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
          left: _isSideBarPressed ? 0 : -(MediaQuery.of(context).size.width*0.95),
          child: ChoosePartsWidget(toggleSideBar: () => _toggleSideBar())
        )

      ],
    );
  }
}



class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, required this.onPressed, required this.iconData, required this.text, this.inkwellBorderRadius}) : super(key: key);
  final Function onPressed;
  final IconData iconData;
  final String text;
  final BorderRadius? inkwellBorderRadius;

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: inkwellBorderRadius ?? const BorderRadius.all(Radius.zero),
        onTap: () => onPressed(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Icon(iconData,color: Colors.white),
              ),
              flex: 1),
            Expanded(
              child: Center(
                child: Text(text, style: TextStyles.interStyle1),
              ),
              flex: 2
            )
          ],
        ),
      ),
    );
  }
}


class CustomPainterAppbar extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.2710280,size.height*0.9827586);
    path_0.lineTo(size.width*0.9154455,size.height*0.9827586);
    path_0.cubicTo(size.width*0.9245327,size.height*0.9827586,size.width*0.9332492,size.height*0.9627776,size.width*0.9396760,size.height*0.9272103);
    path_0.lineTo(size.width*0.9868474,size.height*0.6661379);
    path_0.cubicTo(size.width*0.9932741,size.height*0.6305707,size.width*0.9968847,size.height*0.5823310,size.width*0.9968847,size.height*0.5320328);
    path_0.lineTo(size.width*0.9968847,size.height*0.1896552);
    path_0.cubicTo(size.width*0.9968847,size.height*0.08491155,size.width*0.9815421,0,size.width*0.9626168,0);
    path_0.lineTo(size.width*0.03738318,0);
    path_0.cubicTo(size.width*0.01845754,0,size.width*0.003115265,size.height*0.08491155,size.width*0.003115265,size.height*0.1896552);
    path_0.lineTo(size.width*0.003115265,size.height*0.7931034);
    path_0.cubicTo(size.width*0.003115265,size.height*0.8978466,size.width*0.01845754,size.height*0.9827586,size.width*0.03738318,size.height*0.9827586);
    path_0.lineTo(size.width*0.2710280,size.height*0.9827586);
    path_0.close();

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.006230530;
    paint_0_stroke.color=Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_stroke);

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = Palette.widgetBackground1.withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class CustomPainterSidebar extends CustomPainter{

  final BuildContext context;
  final Function toggleSideBar;
  CustomPainterSidebar(this.context, this.toggleSideBar); // context from CanvasTouchDetector

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context,canvas);

    Path path_0 = Path();
    path_0.moveTo(size.width*0.9297721,size.height*0.1302206);
    path_0.lineTo(size.width*0.4879116,size.height*0.06290526);
    path_0.cubicTo(size.width*0.3438442,size.height*0.04095714,size.width*0.02325581,size.height*0.05194211,size.width*0.02325581,size.height*0.07882657);
    path_0.lineTo(size.width*0.02325581,size.height*0.9233484);
    path_0.cubicTo(size.width*0.02325581,size.height*0.9500025,size.width*0.3393512,size.height*0.9611429,size.width*0.4854674,size.height*0.9396366);
    path_0.lineTo(size.width*0.9273279,size.height*0.8746040);
    path_0.cubicTo(size.width*0.9594372,size.height*0.8698772,size.width*0.9767442,size.height*0.8641729,size.width*0.9767442,size.height*0.8583158);
    path_0.lineTo(size.width*0.9767442,size.height*0.1461419);
    path_0.cubicTo(size.width*0.9767442,size.height*0.1404388,size.width*0.9603326,size.height*0.1348762,size.width*0.9297721,size.height*0.1302206);
    path_0.close();

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.04651163;
    paint_0_stroke.color=Colors.white.withOpacity(1.0);
    myCanvas.drawPath(path_0,paint_0_stroke);

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = Palette.widgetBackground1.withOpacity(1.0);
    myCanvas.drawPath(path_0,paint_0_fill);

    myCanvas.drawPath(path_0, paint_0_fill, onTapDown: (tapDetail) {
      // Navigator.push(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) => const ChoosePartsWidget(),
      //     transitionDuration: Duration.zero,
      //   ),
      // );
      toggleSideBar();
    });

    Path path_1 = Path();
    path_1.moveTo(size.width*0.3488372,size.height*0.8095238);
    path_1.lineTo(size.width*0.6511628,size.height*0.8408521);
    path_1.lineTo(size.width*0.3488372,size.height*0.8721805);

    Paint paint_1_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.04651163;
    paint_1_stroke.color=Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1,paint_1_stroke);

    Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
    paint_1_fill.color = Palette.widgetBackground1.withOpacity(1.0);
    canvas.drawPath(path_1,paint_1_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
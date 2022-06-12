import 'package:flutter/material.dart';
import 'package:project_skripsi/Pages/BuildGuide/BuildGuidePage.dart';
import 'package:project_skripsi/Pages/BuildSchema/ChoosePartsModelWidget.dart';
import 'package:project_skripsi/Pages/BuildSchema/ChoosePartsWidget.dart';
import 'package:project_skripsi/Pages/BuildSchema/PartsInfoWidget.dart';
import 'package:project_skripsi/Pages/Help/HelpPage.dart';
import 'package:project_skripsi/Pages/Settings/SettingsPage.dart';
import 'package:project_skripsi/UI/CustomContainer.dart';
import 'package:provider/provider.dart';
import 'package:touchable/touchable.dart';

import '../Pages/BuildSchema/BuildSchemaStateModel.dart';
import '../Pages/ImportExport/ExportPage.dart';
import '../Pages/ImportExport/ImportPage.dart';
import 'FadeBlackBackground.dart';
import 'Palette.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({Key? key, this.isTextFieldEnabled = false, this.sideBarVisible = true, required this.children, this.isExportDisabled = true}) : super(key: key);

  final bool isTextFieldEnabled;
  final bool sideBarVisible;
  final bool isExportDisabled;
  final List<Widget> children;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  bool _isMenuButtonPressed = false;
  void _toggleMenu() {
    setState(() {
      _isMenuButtonPressed = !_isMenuButtonPressed;
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
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 150,
                    right: 40
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      if(widget.isTextFieldEnabled == true)
                        Consumer<BuildSchemaStateModel>(
                          builder: (context, value, child) => TextField(
                              controller: value.textEditingController,
                              onChanged: (text){
                                value.changeBuildName(text);
                                value.textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: value.textEditingController.text.length));
                              },
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18)
                          ),
                        ),
                    ],
                  ),
                )
            ),
          ),
        ),
        Visibility(
            visible: widget.sideBarVisible,
            child: Consumer<BuildSchemaStateModel>(
              builder: (context, value, child) => AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: value.sidebarToggle ? -50 : 0,
                child: CanvasTouchDetector(
                  gesturesToOverride: const [GestureType.onTapDown],
                  builder: (context) => CustomPaint(
                    size: Size(50,(50*9.279069767441861).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                    painter: CustomPainterSidebar(context, () => value.changeSidebarToggle()),
                  ),
                ),
              ),
            )
        ),
        ...widget.children,
        GestureDetector(
          onTap: (){
            _toggleMenu();
          },
          child: FadeBlackBackground(toggleVariable: _isMenuButtonPressed),
        ),
        Consumer<BuildSchemaStateModel>(
          builder: (context, value, child) => GestureDetector(
            onTap: (){
              value.changeSidebarToggle();
            },
            child: FadeBlackBackground(toggleVariable: value.sidebarToggle),
          )
        ),
        Visibility(
          visible: _isMenuButtonPressed,
          child: Positioned(
              top: 40,
              child: CustomContainer(
                width: 250,
                height: widget.isExportDisabled == false ? 350 : 300,
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                const ImportPage(),
                                transitionDuration: Duration.zero,
                              ),
                            );
                          },
                          iconData: Icons.file_download,
                          text: 'Import Build',
                        )
                    ),
                    const Divider(
                        height: 1,
                        thickness: 2,
                        color: Colors.white
                    ),
                    if(widget.isExportDisabled == false)
                      Expanded(
                          child: Consumer<BuildSchemaStateModel>(
                            builder: (context, value, child) => MenuButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                    ExportPage(
                                      buildSchemaStateModel: value,
                                    ),
                                    transitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              iconData: Icons.file_upload,
                              text: 'Export Build',
                            )
                          )
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
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          iconData: Icons.settings,
                          text: 'Back to menu',
                        )
                    ),
                    // Expanded(
                    //     child: MenuButton(
                    //       onPressed: () {
                    //         _toggleMenu();
                    //         Navigator.push(
                    //           context,
                    //           PageRouteBuilder(
                    //             pageBuilder:
                    //               (context, animation1, animation2) =>
                    //                 const SettingsPage(),
                    //                   transitionDuration: Duration.zero,
                    //           ),
                    //         );
                    //       },
                    //       iconData: Icons.settings,
                    //       text: 'Settings',
                    //     )
                    // ),
                    // const Divider(
                    //     height: 1,
                    //     thickness: 2,
                    //     color: Colors.white
                    // ),
                    // Expanded(
                    //     child: MenuButton(
                    //       onPressed: () {
                    //         _toggleMenu();
                    //         Navigator.push(
                    //           context,
                    //           PageRouteBuilder(
                    //             pageBuilder:
                    //               (context, animation1, animation2) =>
                    //                 const HelpPage(),
                    //                   transitionDuration: Duration.zero,
                    //           ),
                    //         );
                    //       },
                    //       iconData: Icons.help_outline,
                    //       text: 'Help',
                    //       inkwellBorderRadius: const BorderRadius.only(
                    //           bottomLeft: Radius.circular(20),
                    //           bottomRight: Radius.circular(20)
                    //       ),
                    //     )
                    // )
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
        Consumer<BuildSchemaStateModel>(
          builder: (context, schemaState, child){
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 700),
              curve: Curves.fastOutSlowIn,
              left: schemaState.sidebarToggle ? 0 : -(MediaQuery.of(context).size.width*0.95),
              child: ((){
                if(schemaState.sidebarState == 1){
                  return ChoosePartsModelWidget(toggleSideBar: () => schemaState.changeSidebarToggle(), partEnum: schemaState.selectedPartEnum);
                }
                else if(schemaState.sidebarState == 2){
                  return PartsInfoWidget(id: schemaState.selectedPartModelId, partEnum: schemaState.selectedPartEnum, toggleMenu: () => schemaState.changeSidebarToggle());
                }
                else{
                  return ChoosePartsWidget(toggleSideBar: () => schemaState.changeSidebarToggle());
                }
              }())
            );
          }
        ),
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

    Paint paint0Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.006230530;
    paint0Stroke.color=Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0,paint0Stroke);

    Paint paint0Fill = Paint()..style=PaintingStyle.fill;
    paint0Fill.color = Palette.widgetBackground1.withOpacity(1.0);
    canvas.drawPath(path_0,paint0Fill);

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

    Paint paint0Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.04651163;
    paint0Stroke.color=Colors.white.withOpacity(1.0);
    myCanvas.drawPath(path_0,paint0Stroke);

    Paint paint0Fill = Paint()..style=PaintingStyle.fill;
    paint0Fill.color = Palette.widgetBackground1.withOpacity(1.0);
    myCanvas.drawPath(path_0,paint0Fill);

    myCanvas.drawPath(path_0, paint0Fill, onTapDown: (tapDetail) {
      toggleSideBar();
    });

    Path path_1 = Path();
    path_1.moveTo(size.width*0.3488372,size.height*0.8095238);
    path_1.lineTo(size.width*0.6511628,size.height*0.8408521);
    path_1.lineTo(size.width*0.3488372,size.height*0.8721805);

    Paint paint1Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.04651163;
    paint1Stroke.color=Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1,paint1Stroke);

    Paint paint1Fill = Paint()..style=PaintingStyle.fill;
    paint1Fill.color = Palette.widgetBackground1.withOpacity(1.0);
    canvas.drawPath(path_1,paint1Fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
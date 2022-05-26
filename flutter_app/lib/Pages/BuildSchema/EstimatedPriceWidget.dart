import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_skripsi/Functions/CurrencyFormat.dart';
import 'package:project_skripsi/Pages/BuildSchema/BuildSchemaStateModel.dart';
import 'package:project_skripsi/UI/FadeBlackBackground.dart';
import 'package:project_skripsi/Variables/GlobalVariables.dart';
import 'package:provider/provider.dart';

import '../../UI/Palette.dart';

class EstimatedPriceWidget extends StatefulWidget {
  const EstimatedPriceWidget({Key? key, required this.blackBackgroundCallback}) : super(key: key);
  final Function blackBackgroundCallback;
  @override
  State<EstimatedPriceWidget> createState() => _EstimatedPriceWidgetState();
}

class _EstimatedPriceWidgetState extends State<EstimatedPriceWidget> {
  bool _isMenuPressed = false;

  void _toggleMenu() {
    setState(() {
      _isMenuPressed = !_isMenuPressed;
    });
  }

  Widget _getPerformanceBenchmark(BuildSchemaStateModel schemaStateModel){
    List<Widget> list = [];
    if(schemaStateModel.selectedCPU.isNotEmpty){
      list.add(Row(children: [
        Text("Cores / Threads: " + schemaStateModel.selectedCPU[0]['Cores'], style: TextStyles.sourceSans3)
      ]));
      list.add(Row(children: [
        Text("Clock Speed: " + schemaStateModel.selectedCPU[0]['Clock'], style: TextStyles.sourceSans3)
      ]));
    }
    if(schemaStateModel.selectedStorage.isNotEmpty){
      list.add(Row(children: [
        Text("Storage size: " + schemaStateModel.selectedStorage[0]['size'], style: TextStyles.sourceSans3)
      ]));
    }
    if(schemaStateModel.selectedPSU.isNotEmpty){
      list.add(Row(children: [
        Text("Wattage: " + schemaStateModel.selectedPSU[0]['power_W'].toString(), style: TextStyles.sourceSans3)
      ]));
    }
    if(schemaStateModel.selectedRAM.isNotEmpty){
      list.add(Row(children: [
        Text("Ram: " + schemaStateModel.selectedRAM[0]['size_gb'].toString() + " GB " + schemaStateModel.selectedRAM[0]['ram_slot'], style: TextStyles.sourceSans3)
      ]));
    }
    if(schemaStateModel.selectedMotherboard.isNotEmpty){
      list.add(Row(children: [
        Text("Form Factor: " + schemaStateModel.selectedMotherboard[0]['form_factor'], style: TextStyles.sourceSans3)
      ]));
    }
    return(Column(children: list,));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        bottom: _isMenuPressed ? 0 : -MediaQuery.of(context).size.width*0.72*1.3103448275862069,
        right: 0,
        curve: Curves.fastOutSlowIn,
        child: Stack(
          children: [
            FadeBlackBackground(toggleVariable: _isMenuPressed),
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width*0.92, (MediaQuery.of(context).size.width*0.92*1.3103448275862069).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: WidgetPainter(),
            ),
            Visibility(//Point up
              visible: !_isMenuPressed,
              child: Positioned(
                bottom: (MediaQuery.of(context).size.width*0.86*1.3103448275862069).toDouble(),
                right: MediaQuery.of(context).size.width*0.4,
                child: CustomPaint(
                  size: const Size(27, 16), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: ArrowUpPainter(),
                ),
              )
            ),
            Visibility(//Point down
              visible: _isMenuPressed,
              child: Positioned(
                bottom: (MediaQuery.of(context).size.width*0.86*1.3103448275862069).toDouble(),
                right: MediaQuery.of(context).size.width*0.4,
                child: CustomPaint(
                  size: const Size(27, 16), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: ArrowDownPainter(),
                ),
              )
            ),
            Positioned(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _toggleMenu();
                  widget.blackBackgroundCallback();
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.92,
                  height: MediaQuery.of(context).size.height *0.16,
                  //color: Colors.yellow.shade600,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Visibility(
                visible: _isMenuPressed,
                child: Consumer<BuildSchemaStateModel>(
                  builder: (context, value, child) => Container(
                      margin: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width*0.92,
                      height: (MediaQuery.of(context).size.width*0.92*1.3103448275862069) - MediaQuery.of(context).size.height *0.16,
                      child: Column(

                        children: [
                          Row(
                            children: [
                              Text("Estimated Price: "+ CurrencyFormat.convertToIdr(value.calculatePrice(), 0), style: TextStyles.interStyleBuildGuidePage,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Performance Benchmark:", style: TextStyles.interStyleBuildGuidePage,),
                            ],
                          ),
                          _getPerformanceBenchmark(value)
                        ],
                      )
                    //color: Colors.yellow.shade600,
                  ),
                )
              )
            ),

          ],
        ),
        duration: Duration(milliseconds: 500)
    );
  }
}

class WidgetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.008596494,size.height*0.1290404);
    path_0.cubicTo(size.width*0.004871695,size.height*0.1330969,size.width*0.002873563,size.height*0.1379303,size.width*0.002873563,size.height*0.1428838);
    path_0.lineTo(size.width*0.002873563,size.height*0.9736842);
    path_0.cubicTo(size.width*0.002873563,size.height*0.9870066,size.width*0.01702549,size.height*0.9978070,size.width*0.03448276,size.height*0.9978070);
    path_0.lineTo(size.width*0.9655172,size.height*0.9978070);
    path_0.cubicTo(size.width*0.9829741,size.height*0.9978070,size.width*0.9971264,size.height*0.9870066,size.width*0.9971264,size.height*0.9736842);
    path_0.lineTo(size.width*0.9971264,size.height*0.02631579);
    path_0.cubicTo(size.width*0.9971264,size.height*0.01299311,size.width*0.9829741,size.height*0.002192982,size.width*0.9655172,size.height*0.002192982);
    path_0.lineTo(size.width*0.1415167,size.height*0.002192982);
    path_0.cubicTo(size.width*0.1312078,size.height*0.002192982,size.width*0.1215466,size.height*0.006029496,size.width*0.1156305,size.height*0.01247243);
    path_0.lineTo(size.width*0.008596494,size.height*0.1290404);
    path_0.close();

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.005747126;
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

class ArrowDownPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.9629630,size.height*0.06250000);
    path_0.lineTo(size.width*0.5000000,size.height*0.8750000);
    path_0.lineTo(size.width*0.03703704,size.height*0.06249994);

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.07407407;
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

//Copy this CustomPainter code to the Bottom of the File
class ArrowUpPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(1,15);
    path_0.lineTo(13.5,2);
    path_0.lineTo(26,15);

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.07407407;
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
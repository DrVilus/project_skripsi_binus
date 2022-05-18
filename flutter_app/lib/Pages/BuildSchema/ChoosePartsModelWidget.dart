import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_skripsi/Pages/BuildSchema/PartsInfoWidget.dart';
import 'package:project_skripsi/Functions/CurrencyFormat.dart';

import '../../UI/Palette.dart';
import '../../Variables/GlobalVariables.dart';
import '../../Variables/Queries.dart';

class ChoosePartsModelWidget extends StatefulWidget {
  const ChoosePartsModelWidget({Key? key, required this.toggleSideBar, required this.number}) : super(key: key);
  final Function toggleSideBar;
  final ValueListenable<int> number; //index for selected part

  @override
  State<ChoosePartsModelWidget> createState() => _ChoosePartsModelWidgetState();
}

class _ChoosePartsModelWidgetState extends State<ChoosePartsModelWidget> {

  int getLowestPrice(List queryResult, int index){
    if(queryResult[index][getQueryPriceText(widget.number.value)].length == 0){
      return 0;
    }
    return queryResult[index][getQueryPriceText(widget.number.value)][0]['price']!;
  }

  bool _partModelSelected = false;
  String _selectedPartModelId = '';
  void _togglePartModelSelected(){
    setState(() {
      _partModelSelected = !_partModelSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_partModelSelected == true && _selectedPartModelId.isNotEmpty){
      return PartsInfoWidget(id: _selectedPartModelId, partType: widget.number.value, toggleMenu: _togglePartModelSelected);
    }
    return SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width*0.95, (MediaQuery.of(context).size.height).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
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
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.82,
                    height: (MediaQuery.of(context).size.height*0.07).toDouble(),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left,color: Colors.white),
                          tooltip: 'Back',
                          iconSize: 30,
                          onPressed: () {
                            widget.toggleSideBar();
                          },
                        ),
                        Text(partSelectModelList[widget.number.value].name, style: TextStyles.sourceSans3,),
                      ],
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width*0.82,
                      height: (MediaQuery.of(context).size.height*0.92).toDouble(),
                      child: Query(
                        options: QueryOptions(
                          document: gql(partSelectModelList[widget.number.value].query), // this is the query string you just created
                        ),
                        // Just like in apollo refetch() could be used to manually trigger a refetch
                        // while fetchMore() can be used for pagination purpose
                        builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }) {
                          if (result.hasException) {
                            return Text(result.exception.toString());
                          }

                          if (result.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }

                          List? data = getQueryList(result, widget.number.value);

                          if (data == null) {
                            return const Text('No repositories');
                          }
                          return Scrollbar(
                              child: CustomScrollView(
                                slivers: <Widget>[
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                        return Container(
                                            alignment: Alignment.center,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                left: 40,
                                                right: 10,
                                                top: 10,
                                                bottom: 10
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(child: Text(data[index]['name'], style: TextStyles.interStyle1,))
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                        child: Image.asset(partSelectModelList[widget.number.value].assetPath),
                                                        width: 100,
                                                        height: 100,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(CurrencyFormat.convertToIdr(getLowestPrice(data,index), 2).toString(), style: TextStyles.interStyle1),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              _selectedPartModelId = data[index]['id'];
                                                              _togglePartModelSelected();
                                                            },
                                                            child: Text("Info", style: TextStyles.interStyle1)
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                            },
                                                            child: Text("Add", style: TextStyles.interStyle1),
                                                            style: ElevatedButton.styleFrom(
                                                              primary: Colors.green
                                                            )
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                            )
                                        );
                                      },
                                      childCount: data.length,
                                    ),
                                  ),
                                ],
                              )
                          );
                        },
                      )
                  ),
                ],
              )
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
    path_0.moveTo(size.width*0.9059635,size.height*0.01098174);
    path_0.lineTo(size.width*0.9827893,size.height*0.05671581);
    path_0.cubicTo(size.width*0.9920421,size.height*0.06222473,size.width*0.9971910,size.height*0.06948779,size.width*0.9971910,size.height*0.07703302);
    path_0.lineTo(size.width*0.9971910,size.height*0.7390360);
    path_0.cubicTo(size.width*0.9971910,size.height*0.7443396,size.width*0.9946433,size.height*0.7495477,size.width*0.9898146,size.height*0.7541189);
    path_0.lineTo(size.width*0.8967079,size.height*0.8422426);
    path_0.cubicTo(size.width*0.8913708,size.height*0.8472958,size.width*0.8885562,size.height*0.8530516,size.width*0.8885562,size.height*0.8589139);
    path_0.lineTo(size.width*0.8885562,size.height*0.9687011);
    path_0.cubicTo(size.width*0.8885562,size.height*0.9851221,size.width*0.8646601,size.height*0.9984351,size.width*0.8351854,size.height*0.9984351);
    path_0.lineTo(size.width*0.002808989,size.height*0.9984351);
    path_0.lineTo(size.width*0.002808989,size.height*0.001564945);
    path_0.lineTo(size.width*0.8669972,size.height*0.001564945);
    path_0.cubicTo(size.width*0.8817640,size.height*0.001564945,size.width*0.8958736,size.height*0.004974272,size.width*0.9059635,size.height*0.01098174);
    path_0.close();

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.005617978;
    paint_0_stroke.color=Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_stroke);

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = Color(0xff1E1E1E).withOpacity(1.0);
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
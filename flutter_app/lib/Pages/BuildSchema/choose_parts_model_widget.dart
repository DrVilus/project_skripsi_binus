import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_skripsi/Functions/compatibility_check_functions.dart';
import 'package:project_skripsi/Functions/currency_format.dart';
import 'package:project_skripsi/Functions/generic_ui_functions.dart';
import 'package:project_skripsi/Pages/BuildSchema/build_schema_state_model.dart';
import 'package:provider/provider.dart';

import '../../UI/palette.dart';
import '../../Variables/global_variables.dart';
import '../../Variables/graphql_client.dart';

class ChoosePartsModelWidget extends StatefulWidget {
  const ChoosePartsModelWidget(
      {Key? key, required this.toggleSideBar, required this.partEnum})
      : super(key: key);
  final Function toggleSideBar;
  final PartEnum partEnum;

  @override
  State<ChoosePartsModelWidget> createState() => _ChoosePartsModelWidgetState();
}

class _ChoosePartsModelWidgetState extends State<ChoosePartsModelWidget> {
  int _compatibleIndexLength = 10000;

  num _getLowestPrice(List queryResult, int index) {
    if (queryResult[index][GlobalVariables.getQueryPriceText(widget.partEnum)]
            .length ==
        0) {
      return 0;
    }
    return queryResult[index]
        [GlobalVariables.getQueryPriceText(widget.partEnum)][0]['price']!;
  }

  Future<List> _getPartData(String id) async {
    final QueryOptions options = QueryOptions(
      document: gql(GlobalVariables.partSelectModelList
          .where((q) => q.partEnumVariable == widget.partEnum)
          .first
          .queryById),
      variables: {
        'id': id,
      },
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }

    return GlobalVariables.getQueryList(result, widget.partEnum);
  }

  void _addPart(BuildSchemaStateModel schemaState, List data, int index) async {
    var result = schemaState.changePart(
        await _getPartData(data[index]['id']), widget.partEnum);
    if (result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          GenericUIFunctions.snackBar("Added " + data[0]['name']));
      widget.toggleSideBar();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(GenericUIFunctions.snackBar(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    var selectedPartModel = GlobalVariables.partSelectModelList
        .where((q) => q.partEnumVariable == widget.partEnum)
        .first;
    return SafeArea(
        child: Stack(
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width * 0.95,
              (MediaQuery.of(context).size.height).toDouble()),
          //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
          painter: WidgetBackgroundPainter(),
        ),
        Positioned(
          right: 50,
          top: 50,
          child: CustomPaint(
            size: Size(2, MediaQuery.of(context).size.height * 0.55),
            //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
            painter: LinePainter(),
          ),
        ),
        Positioned(
          right: 10,
          top: MediaQuery.of(context).size.height * 0.3,
          child: CustomPaint(
            size: const Size(16, 27),
            //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
            painter: ArrowPainter(),
          ),
        ),
        Positioned(
            top: 0,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.82,
                  height:
                      (MediaQuery.of(context).size.height * 0.07).toDouble(),
                  child: Row(
                    children: [
                      Consumer<BuildSchemaStateModel>(
                        builder: (context, schemaState, child) => IconButton(
                          icon: const Icon(Icons.chevron_left,
                              color: Colors.white),
                          tooltip: 'Back',
                          iconSize: 30,
                          onPressed: () {
                            schemaState.changeSidebarState(
                                schemaState.sidebarState - 1);
                          },
                        ),
                      ),
                      Text(
                        selectedPartModel.name,
                        style: TextStyles.sourceSans3,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.82,
                  height:
                      (MediaQuery.of(context).size.height * 0.92).toDouble(),
                  child: Consumer<BuildSchemaStateModel>(
                    builder: (context, schemaState, child) => Query(
                      options: QueryOptions(
                        document: gql(selectedPartModel
                            .query), // this is the query string you just created
                      ),
                      // Just like in apollo refetch() could be used to manually trigger a refetch
                      // while fetchMore() can be used for pagination purpose
                      builder: (QueryResult result,
                          {VoidCallback? refetch, FetchMore? fetchMore}) {
                        _compatibleIndexLength = 1000000;
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

                        List? data = GlobalVariables.getQueryList(
                            result, widget.partEnum);
                        if (data.isEmpty) {
                          return const Text('No data found');
                        }

                        //////////////////////////////////////////////////////////////////////////////////////
                        //Sorting Stuffs
                        //when choosing cpu
                        if (widget.partEnum == PartEnum.cpu) {
                          if (schemaState.selectedMotherboard.isNotEmpty) {
                            var incompatibleData = data
                                .where((element) =>
                                    element['socket_name'] !=
                                    schemaState.selectedMotherboard[0]
                                        ['cpu_socket'])
                                .toList();
                            data.removeWhere((element) =>
                                element['socket_name'] !=
                                schemaState.selectedMotherboard[0]
                                    ['cpu_socket']);
                            _compatibleIndexLength = data.length;
                            data.insertAll(data.length, incompatibleData);
                          }
                        }

                        //when choosing motherboard
                        if (widget.partEnum == PartEnum.motherboard) {
                          if (schemaState.selectedCPU.isNotEmpty) {
                            var incompatibleData = data
                                .where((element) =>
                                    element['cpu_socket'] !=
                                    schemaState.selectedCPU[0]['socket_name'])
                                .toList();
                            data.removeWhere((element) =>
                                element['cpu_socket'] !=
                                schemaState.selectedCPU[0]['socket_name']);
                            _compatibleIndexLength = data.length;
                            data.insertAll(data.length, incompatibleData);
                          }
                        }

                        //when choosing gpu
                        if (widget.partEnum == PartEnum.gpu) {
                          var tempDataList = [];
                          if (schemaState.selectedMotherboard.isNotEmpty) {
                            Map<String, dynamic> serializedJson = jsonDecode(
                                schemaState.selectedMotherboard[0]
                                    ['pcie_slots_json']);
                            var deletedData = data
                                .where((element) =>
                                    (CompatibilityCheckFunctions()
                                            .handlePcieCompatibilityWithJson(
                                                element['interface_bus'],
                                                serializedJson) ==
                                        false))
                                .toList();
                            data.removeWhere((element) =>
                                CompatibilityCheckFunctions()
                                    .handlePcieCompatibilityWithJson(
                                        element['interface_bus'],
                                        serializedJson) ==
                                false);
                            tempDataList.addAll(deletedData);
                          }

                          int selectedPsuWattage = 9999;
                          if (schemaState.selectedPSU.isNotEmpty) {
                            selectedPsuWattage =
                                schemaState.selectedPSU[0]['power_W'];
                            var deletedData = data
                                .where((element) =>
                                    (element['recommended_wattage'] >
                                        selectedPsuWattage))
                                .toList();
                            data.removeWhere((element) =>
                                (element['recommended_wattage'] >
                                    selectedPsuWattage));
                            tempDataList.addAll(deletedData);
                          }

                          if (tempDataList.isNotEmpty) {
                            _compatibleIndexLength = data.length;
                            data.insertAll(data.length, tempDataList);
                          }
                        }

                        //when choosing PSU
                        if (widget.partEnum == PartEnum.psu) {
                          if (schemaState.selectedGPU.isNotEmpty) {
                            var deletedData = data
                                .where((element) => (element['power_W'] <
                                    schemaState.selectedGPU[0]
                                        ['recommended_wattage']))
                                .toList();
                            data.removeWhere((element) => (element['power_W'] <
                                schemaState.selectedGPU[0]
                                    ['recommended_wattage']));
                            _compatibleIndexLength = data.length;
                            data.insertAll(data.length, deletedData);
                          }
                        }

                        if (schemaState
                            .checkPartChosenId(widget.partEnum)
                            .isNotEmpty) {
                          var selectedData = data
                              .where((element) =>
                                  element['id'] ==
                                  schemaState
                                      .checkPartChosenId(widget.partEnum))
                              .first;
                          data.remove(selectedData);
                          data.insert(0, selectedData);
                        }
                        ////////////////////////////////////////////////////////////////////////////////////////
                        return Scrollbar(
                            child: CustomScrollView(
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: (schemaState
                                                      .checkPartChosenId(
                                                          widget.partEnum)
                                                      .isNotEmpty &&
                                                  index == 0)
                                              ? Colors.grey.withAlpha(100)
                                              : (index < _compatibleIndexLength)
                                                  ? null
                                                  : Colors.red.withAlpha(100)),
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 40,
                                              right: 10,
                                              top: 10,
                                              bottom: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Consumer<
                                                      BuildSchemaStateModel>(
                                                    builder: (context, value,
                                                            child) =>
                                                        (widget.partEnum ==
                                                                    PartEnum
                                                                        .ram &&
                                                                value
                                                                    .checkPartChosenId(
                                                                        PartEnum
                                                                            .ram)
                                                                    .isNotEmpty &&
                                                                index == 0)
                                                            ? Flexible(
                                                                child: Text(
                                                                data[index][
                                                                        'name'] +
                                                                    " x" +
                                                                    value
                                                                        .currentSelectedRAMCount
                                                                        .toString(),
                                                                style: TextStyles
                                                                    .sourceSans3,
                                                              ))
                                                            : Flexible(
                                                                child: Text(
                                                                data[index]
                                                                    ['name'],
                                                                style: TextStyles
                                                                    .sourceSans3,
                                                              )),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    child: Image.asset(
                                                        selectedPartModel
                                                            .assetPath),
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                          CurrencyFormat
                                                                  .convertToIdr(
                                                                      _getLowestPrice(
                                                                          data,
                                                                          index),
                                                                      2)
                                                              .toString(),
                                                          style: TextStyles
                                                              .interStyle1),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            schemaState
                                                                .changeSelectedPartModelId(
                                                                    data[index]
                                                                        ['id']);
                                                            schemaState
                                                                .changeSidebarState(
                                                                    2);
                                                            // _selectedPartModelId = data[index]['id'];
                                                            // _togglePartModelSelected();
                                                          },
                                                          child: Text("Info",
                                                              style: TextStyles
                                                                  .interStyle1)),
                                                      (schemaState
                                                                  .checkPartChosenId(
                                                                      widget
                                                                          .partEnum)
                                                                  .isEmpty ||
                                                              index != 0)
                                                          ? ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                //For multi count part input check
                                                                if (widget
                                                                        .partEnum ==
                                                                    PartEnum
                                                                        .ram) {
                                                                  GenericUIFunctions
                                                                      .countInputModalBottomSheetRam(
                                                                          context,
                                                                          (input) async {
                                                                    _addPart(
                                                                        schemaState,
                                                                        data,
                                                                        index);
                                                                    schemaState
                                                                            .currentSelectedRAMCount =
                                                                        input;
                                                                  });
                                                                } else {
                                                                  _addPart(
                                                                      schemaState,
                                                                      data,
                                                                      index);
                                                                }
                                                              },
                                                              child: Text("Add",
                                                                  style: TextStyles
                                                                      .interStyle1),
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary: Colors
                                                                          .green))
                                                          : ElevatedButton(
                                                              onPressed: () {
                                                                schemaState
                                                                    .removePart(
                                                                        widget
                                                                            .partEnum);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(GenericUIFunctions.snackBar("Removed " +
                                                                        data[index]
                                                                            [
                                                                            'name']));
                                                              },
                                                              child: Text(
                                                                  "Remove",
                                                                  style: TextStyles
                                                                      .interStyle1),
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .red))
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                  )
                                                ],
                                              )
                                            ],
                                          )));
                                },
                                childCount: data.length,
                              ),
                            ),
                          ],
                        ));
                      },
                    ),
                  ),
                ),
              ],
            )),
        Positioned(
          right: 0,
          top: 10,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              widget.toggleSideBar();
            },
            child: SizedBox(
              width: 50,
              height: MediaQuery.of(context).size.height * 0.7,
              //color: Colors.yellow.shade600,
            ),
          ),
        ),
      ],
    ));
  }
}

//Copy this CustomPainter code to the Bottom of the File
class WidgetBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9059635, size.height * 0.01098174);
    path_0.lineTo(size.width * 0.9827893, size.height * 0.05671581);
    path_0.cubicTo(
        size.width * 0.9920421,
        size.height * 0.06222473,
        size.width * 0.9971910,
        size.height * 0.06948779,
        size.width * 0.9971910,
        size.height * 0.07703302);
    path_0.lineTo(size.width * 0.9971910, size.height * 0.7390360);
    path_0.cubicTo(
        size.width * 0.9971910,
        size.height * 0.7443396,
        size.width * 0.9946433,
        size.height * 0.7495477,
        size.width * 0.9898146,
        size.height * 0.7541189);
    path_0.lineTo(size.width * 0.8967079, size.height * 0.8422426);
    path_0.cubicTo(
        size.width * 0.8913708,
        size.height * 0.8472958,
        size.width * 0.8885562,
        size.height * 0.8530516,
        size.width * 0.8885562,
        size.height * 0.8589139);
    path_0.lineTo(size.width * 0.8885562, size.height * 0.9687011);
    path_0.cubicTo(
        size.width * 0.8885562,
        size.height * 0.9851221,
        size.width * 0.8646601,
        size.height * 0.9984351,
        size.width * 0.8351854,
        size.height * 0.9984351);
    path_0.lineTo(size.width * 0.002808989, size.height * 0.9984351);
    path_0.lineTo(size.width * 0.002808989, size.height * 0.001564945);
    path_0.lineTo(size.width * 0.8669972, size.height * 0.001564945);
    path_0.cubicTo(
        size.width * 0.8817640,
        size.height * 0.001564945,
        size.width * 0.8958736,
        size.height * 0.004974272,
        size.width * 0.9059635,
        size.height * 0.01098174);
    path_0.close();

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.005617978;
    paint0Stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff1E1E1E).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width;
    paint0Stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(Offset(size.width * 0.5000000, size.height * 1.300935e-10),
        Offset(size.width * 0.4999925, size.height), paint0Stroke);
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
    path_0.moveTo(15, 26);
    path_0.lineTo(2, 13.5);
    path_0.lineTo(15, 1);

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1250000;
    paint0Stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Palette.widgetBackground1;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

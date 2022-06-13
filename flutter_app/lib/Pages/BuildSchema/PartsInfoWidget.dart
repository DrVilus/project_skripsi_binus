import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Functions/GenericUIFunctions.dart';
import '../../UI/Palette.dart';
import '../../Functions/CurrencyFormat.dart';
import '../../Variables/GlobalVariables.dart';
import 'BuildSchemaStateModel.dart';
import 'ChoosePartsModelWidget.dart';

class PartsInfoWidget extends StatefulWidget {
  const PartsInfoWidget({Key? key, required this.id, required this.partEnum, required this.toggleMenu}) : super(key: key);
  final String id;
  final PartEnum partEnum;
  final Function toggleMenu;

  @override
  State<PartsInfoWidget> createState() => _PartsInfoWidgetState();
}

class _PartsInfoWidgetState extends State<PartsInfoWidget> {

  num getLowestPrice(List queryResult, int index){
    if(queryResult[index][getQueryPriceText(widget.partEnum)].length == 0){
      return 0;
    }
    return queryResult[index][getQueryPriceText(widget.partEnum)][0]['price']!;
  }

  Widget createModelInformation(List query){
    List<Widget> list = [];
    query[0].forEach((k, v){
      if(k.toString().contains("json")){
        Map<String,dynamic> serializedJson = jsonDecode(v);
        list.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(reformatStringInfo(k) + ":", style: TextStyles.sourceSans3,)
          ],
        ));
        serializedJson.forEach((k2, v2){
          for(int i = 0; i<v2.length; i++){
            list.add(Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(v2[i], style: TextStyles.sourceSans3,)
              ],
            ));
          }
        });
      }else if(!k.toString().contains("price") &&
          !k.toString().contains("id") &&
          !k.toString().contains("typename") &&
          !k.toString().contains("name")){
        list.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Text(reformatStringInfo(k) + ": $v", style: TextStyles.sourceSans3,))
          ],
        ));
      }
    });

    return Column(children: list);
  }

  String reformatStringInfo(String text){
    text = text.replaceAll(RegExp('_'), ' ');
    text = text.replaceAll(RegExp('json'), '');
    return toBeginningOfSentenceCase(text)!;
  }

  void _launchUrl(String input) async {
    Uri _url = Uri.parse(input);
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  void _addPart(BuildSchemaStateModel value, List data) async{
    if(widget.partEnum == PartEnum.ram){
      GenericUIFunctions.countInputModalBottomSheetRam(context,(input){
        var result = value.changePart(data, widget.partEnum);
        if(result.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(GenericUIFunctions.snackBar("Added " + data[0]['name']));
          value.currentSelectedRAMCount = input;
          widget.toggleMenu();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(GenericUIFunctions.snackBar(result));
        }
      });
    }else{
      var result = value.changePart(data, widget.partEnum);
      if(result.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(GenericUIFunctions.snackBar("Added " + data[0]['name']));
        widget.toggleMenu();
      }else{
        ScaffoldMessenger.of(context).showSnackBar(GenericUIFunctions.snackBar(result));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var selectedPartModel = partSelectModelList.where((q) => q.partEnumVariable == widget.partEnum).first;

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
                          Consumer<BuildSchemaStateModel>(
                            builder: (context, schemaState, child) => IconButton(
                              icon: const Icon(Icons.chevron_left,color: Colors.white),
                              tooltip: 'Back',
                              iconSize: 30,
                              onPressed: () {
                                schemaState.changeSidebarState(schemaState.sidebarState - 1);
                              },
                            ),
                          ),
                          Text(selectedPartModel.name, style: TextStyles.sourceSans3,),
                        ],
                      ),
                    ),
                    Query(
                      options: QueryOptions(
                        document: gql(selectedPartModel.queryById), // this is the query string you just created
                        variables: {
                          'id': widget.id,
                        },
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

                        List? data = getQueryList(result, widget.partEnum);

                        if (data.isEmpty) {
                          return const Text('No repositories');
                        }
                        return SizedBox(
                            width: MediaQuery.of(context).size.width*0.82,
                            height: (MediaQuery.of(context).size.height*0.9).toDouble(),
                            child:Container(
                              margin: const EdgeInsets.only(
                                  top: 20,
                                  left: 50,
                                  right: 50,
                                  bottom: 10
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Consumer<BuildSchemaStateModel>(builder: (context, value, child) =>
                                        (widget.partEnum == PartEnum.ram && value.checkPartChosenId(PartEnum.ram).isNotEmpty) ?
                                          Flexible(child: Text(data[0]['name'] + " x" + value.currentSelectedRAMCount.toString(), style: TextStyles.sourceSans3,))
                                            :
                                          Flexible(child: Text(data[0]['name'], style: TextStyles.sourceSans3,)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Image.asset(selectedPartModel.assetPath),
                                        width: 200,
                                        height: 200,
                                      )],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Consumer<BuildSchemaStateModel>(builder: (context, value, child) =>
                                      (widget.partEnum == PartEnum.ram && value.checkPartChosenId(PartEnum.ram).isNotEmpty) ?
                                          Flexible(child: Text("Price: " + CurrencyFormat.convertToIdr(getLowestPrice(data,0), 2).toString() + " x" + value.currentSelectedRAMCount.toString(), style: TextStyles.sourceSans3,))
                                          :
                                          Flexible(child:Text("Price: " + CurrencyFormat.convertToIdr(getLowestPrice(data,0), 2).toString(), style: TextStyles.sourceSans3,)),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("Description: ", style: TextStyles.sourceSans3,)],
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Container(
                                        child: createModelInformation(data),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      children: [Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [Consumer<BuildSchemaStateModel>(
                                          builder: (context, value, child) => (value.checkPartChosenId(widget.partEnum).isEmpty) ?
                                          ElevatedButton(
                                              onPressed:() {
                                                _addPart(value, data);
                                              },
                                              child: Text("Add", style: TextStyles.interStyle1),

                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.green
                                              )) :
                                          ElevatedButton(
                                              onPressed:() {
                                                value.removePart(widget.partEnum);
                                                ScaffoldMessenger.of(context).showSnackBar(GenericUIFunctions.snackBar("Removed " + data[0]['name']));
                                              },
                                              child: Text("Remove", style: TextStyles.interStyle1),

                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red
                                              )
                                          )
                                          ,
                                        )],
                                      ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [ElevatedButton(
                                              onPressed: () {
                                                //print(data[0][getQueryPriceText(widget.partEnum)][0]['shop_link']!);
                                                _launchUrl(data[0][getQueryPriceText(widget.partEnum)][0]['shop_link']!);
                                              },
                                              child: Text("Visit Store Page", style: TextStyles.interStyle1)
                                          ),],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        );
                      },
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
                  widget.toggleMenu();
                },
                child: SizedBox(
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
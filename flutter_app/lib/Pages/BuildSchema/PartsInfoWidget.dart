import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import '../../UI/Palette.dart';
import '../../Functions/CurrencyFormat.dart';
import '../../Variables/GlobalVariables.dart';
import 'ChoosePartsModelWidget.dart';

class PartsInfoWidget extends StatefulWidget {
  const PartsInfoWidget({Key? key, required this.id, required this.partType, required this.toggleMenu}) : super(key: key);
  final String id;
  final int partType;
  final Function toggleMenu;

  @override
  State<PartsInfoWidget> createState() => _PartsInfoWidgetState();
}

class _PartsInfoWidgetState extends State<PartsInfoWidget> {

  int getLowestPrice(List queryResult, int index){
    if(queryResult[index][getQueryPriceText(widget.partType)].length == 0){
      return 0;
    }
    return queryResult[index][getQueryPriceText(widget.partType)][0]['price']!;
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
            Text(reformatStringInfo(k) + ": $v", style: TextStyles.sourceSans3,)
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

  @override
  Widget build(BuildContext context) {
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
                              widget.toggleMenu();
                            },
                          ),
                          Text(partSelectModelList[widget.partType].name, style: TextStyles.sourceSans3,),
                        ],
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width*0.82,
                        height: (MediaQuery.of(context).size.height*0.8).toDouble(),
                        child: Query(
                          options: QueryOptions(
                            document: gql(partSelectModelList[widget.partType].queryById), // this is the query string you just created
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

                            List? data = getQueryList(result, widget.partType);

                            if (data == null) {
                              return const Text('No repositories');
                            }
                            return Container(
                              margin: const EdgeInsets.only(
                                top: 20,
                                left: 50,
                                right: 50,
                                bottom: 10
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(child: Text(data[0]['name'], style: TextStyles.sourceSans3,))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Image.asset(partSelectModelList[widget.partType].assetPath),
                                        width: 200,
                                        height: 200,
                                      )],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("Price: " + CurrencyFormat.convertToIdr(getLowestPrice(data,0), 2).toString(), style: TextStyles.sourceSans3,)],
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
                                  )
                                ],
                              ),
                            );
                          },
                        )
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [ElevatedButton(
                              onPressed:() {
                              },
                              child: Text("Add", style: TextStyles.interStyle1),

                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green
                              )
                          )],
                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [ElevatedButton(
                                onPressed: () {
                                },
                                child: Text("Visit Store Page", style: TextStyles.interStyle1)
                            ),],
                          ),
                        ],
                      ),
                    )
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
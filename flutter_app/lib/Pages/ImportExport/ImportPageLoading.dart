import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_skripsi/Models/RecommendationModels.dart';
import 'package:project_skripsi/Variables/Queries.dart';

import '../../UI/CustomAppBarBack.dart';
import '../../UI/Palette.dart';
import '../../Variables/GlobalVariables.dart';
import '../../Variables/GraphQLClient.dart';
import '../BuildSchema/BuildSchemaPage.dart';

class ImportLoadingPage extends StatefulWidget {
  const ImportLoadingPage({Key? key, required this.importBuildCode}) : super(key: key);
  final String importBuildCode;

  @override
  State<ImportLoadingPage> createState() => _ImportLoadingPageState();
}

class _ImportLoadingPageState extends State<ImportLoadingPage> {
  bool _isError = false;
  String _loadingMessage = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => executeAfterBuild());
  }

  Future<void> executeAfterBuild() async {
    var splitString = widget.importBuildCode.split("/");
    if(splitString.length != 9 && widget.importBuildCode.length != 65){
      setState(() {
        _isError = true;
        _loadingMessage = "Invalid Code";
      });
      return;
    }

    setState(() {
      _loadingMessage = "Obtaining Case Data";
    });
    var caseOutput = await _getCaseGraphQL(splitString[0]);

    setState(() {
      _loadingMessage = "Obtaining Cooler Data";
    });
    var coolingOutput = await _getCoolerGraphQL(splitString[1]);

    setState(() {
      _loadingMessage = "Obtaining Motherboard Data";
    });
    var motherboardOutput = await _getMotherboardGraphQL(splitString[2]);

    setState(() {
      _loadingMessage = "Obtaining GPU Data";
    });
    var gpuOutput = await _getGpuGraphQL(splitString[3]);

    setState(() {
      _loadingMessage = "Obtaining CPU Data";
    });
    var cpuOutput = await _getCpuGraphQL(splitString[4]);

    setState(() {
      _loadingMessage = "Obtaining PSU Data";
    });
    var psuOutput = await _getPsuGraphQL(splitString[5]);

    setState(() {
      _loadingMessage = "Obtaining RAM Data";
    });
    var ramOutput = await _getRamGraphQL(splitString[6]);

    var ramCount = int.parse(splitString[7]);

    setState(() {
      _loadingMessage = "Obtaining Storage Data";
    });
    var storageOutput = await _getStorageGraphQL(splitString[8]);

    FullPcPartModel  fullPcPartModel = FullPcPartModel(
        CpuMotherboardPair(cpuOutput[0], motherboardOutput[0]),
        GpuPsuPair(gpuOutput[0], psuOutput[0]),
        caseOutput[0],
        storageOutput[0],
        ramOutput[0],
        ramCount,
        coolingOutput[0]);


    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => BuildSchemaPage(fullPcPartModelList: fullPcPartModel),
      ),
    );
  }

  Future<List> _getCpuGraphQL(String cpuIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(cpuQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }

    var list = getQueryList(result, PartEnum.cpu);
    for(int i = 0; i < list.length; i++){
      if(list[i]['id'].toString().startsWith(cpuIdFront)){
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getMotherboardGraphQL(String motherboardIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(motherboardQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    var list = getQueryList(result, PartEnum.motherboard);
    for(int i = 0; i < list.length; i++){
      if(list[i]['id'].toString().startsWith(motherboardIdFront)){
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getGpuGraphQL(String gpuIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(gpuQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    var list =  getQueryList(result, PartEnum.gpu);
    for(int i = 0; i < list.length; i++){
      if(list[i]['id'].toString().startsWith(gpuIdFront)){
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getPsuGraphQL(String psuIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(psuQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    var list = getQueryList(result, PartEnum.psu);
    for(int i = 0; i < list.length; i++){
      if(list[i]['id'].toString().startsWith(psuIdFront)){
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getRamGraphQL(String ramIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(ramQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    var list = getQueryList(result, PartEnum.ram);
    for(int i = 0; i < list.length; i++){
      if(list[i]['id'].toString().startsWith(ramIdFront)){
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getStorageGraphQL(String storageIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(storageQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    var list = getQueryList(result, PartEnum.storage);
    for(int i = 0; i < list.length; i++){
      if(list[i]['id'].toString().startsWith(storageIdFront)){
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getCoolerGraphQL(String coolingIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(coolingQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    var list = getQueryList(result, PartEnum.cooling);
    for(int i = 0; i < list.length; i++){
      if(list[i]['id'].toString().startsWith(coolingIdFront)){
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getCaseGraphQL(String caseIdFront) async {
    final QueryOptions options = QueryOptions(
        document: gql(caseQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    var list = getQueryList(result, PartEnum.pcCase);
    for(int i = 0; i < list.length; i++){
      if(list[i]['id'].toString().startsWith(caseIdFront)){
        return [list[i]];
      }
    }
    return List.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomAppBarBack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(_isError == false)
                    const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  if(_isError)
                    Container(),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(_loadingMessage, style: TextStyles.sourceSans3),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}

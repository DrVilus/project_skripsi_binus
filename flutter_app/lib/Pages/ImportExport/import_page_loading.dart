import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_skripsi/Models/recommendation_models.dart';

import '../../UI/custom_app_bar_back.dart';
import '../../UI/palette.dart';
import '../../Variables/Queries.dart';
import '../../Variables/global_variables.dart';
import '../../Variables/graphql_client.dart';
import '../BuildSchema/build_schema_page.dart';

class ImportLoadingPage extends StatefulWidget {
  const ImportLoadingPage({Key? key, required this.importBuildCode})
      : super(key: key);
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
    if (splitString.length != 9 && widget.importBuildCode.length != 65) {
      setState(() {
        _isError = true;
        _loadingMessage = "Invalid Code";
      });
      return;
    }

    setState(() {
      _loadingMessage = "Obtaining Case Data";
    });
    Map<String, dynamic>? caseOutput;
    if (splitString[0] != "0") {
      caseOutput = (await _getCaseGraphQL(splitString[0]))[0];
    }

    setState(() {
      _loadingMessage = "Obtaining Cooler Data";
    });
    Map<String, dynamic>? coolingOutput;
    if (splitString[1] != "0") {
      coolingOutput =
          coolingOutput = (await _getCoolerGraphQL(splitString[1]))[0];
    }

    setState(() {
      _loadingMessage = "Obtaining Motherboard Data";
    });
    Map<String, dynamic>? motherboardOutput;
    if (splitString[2] != "0") {
      motherboardOutput = (await _getMotherboardGraphQL(splitString[2]))[0];
    }

    setState(() {
      _loadingMessage = "Obtaining GPU Data";
    });
    Map<String, dynamic>? gpuOutput;
    if (splitString[3] != "0") {
      gpuOutput = (await _getGpuGraphQL(splitString[3]))[0];
    }

    setState(() {
      _loadingMessage = "Obtaining CPU Data";
    });
    Map<String, dynamic>? cpuOutput;
    if (splitString[4] != "0") {
      cpuOutput = (await _getCpuGraphQL(splitString[4]))[0];
    }

    setState(() {
      _loadingMessage = "Obtaining PSU Data";
    });
    Map<String, dynamic>? psuOutput;
    if (splitString[5] != "0") {
      psuOutput = (await _getPsuGraphQL(splitString[5]))[0];
    }

    setState(() {
      _loadingMessage = "Obtaining RAM Data";
    });
    Map<String, dynamic>? ramOutput;
    if (splitString[6] != "0") {
      ramOutput = (await _getRamGraphQL(splitString[6]))[0];
    }

    var ramCount = int.parse(splitString[7]);

    setState(() {
      _loadingMessage = "Obtaining Storage Data";
    });
    Map<String, dynamic>? storageOutput;
    if (splitString[8] != "0") {
      storageOutput = (await _getStorageGraphQL(splitString[8]))[0];
    }

    FullPcPartModel fullPcPartModel = FullPcPartModel(
        CpuMotherboardPair(cpuOutput, motherboardOutput),
        GpuPsuPair(gpuOutput, psuOutput),
        caseOutput,
        storageOutput,
        ramOutput,
        ramCount,
        coolingOutput);

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            BuildSchemaPage(fullPcPartModelList: fullPcPartModel),
      ),
    );
  }

  Future<List> _getCpuGraphQL(String cpuIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.cpuQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return List.empty();
    }

    var list = GlobalVariables.getQueryList(result, PartEnum.cpu);
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'].toString().startsWith(cpuIdFront)) {
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getMotherboardGraphQL(String motherboardIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.motherboardQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return List.empty();
    }
    var list = GlobalVariables.getQueryList(result, PartEnum.motherboard);
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'].toString().startsWith(motherboardIdFront)) {
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getGpuGraphQL(String gpuIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.gpuQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return List.empty();
    }
    var list = GlobalVariables.getQueryList(result, PartEnum.gpu);
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'].toString().startsWith(gpuIdFront)) {
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getPsuGraphQL(String psuIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.psuQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return List.empty();
    }
    var list = GlobalVariables.getQueryList(result, PartEnum.psu);
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'].toString().startsWith(psuIdFront)) {
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getRamGraphQL(String ramIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.ramQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return List.empty();
    }
    var list = GlobalVariables.getQueryList(result, PartEnum.ram);
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'].toString().startsWith(ramIdFront)) {
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getStorageGraphQL(String storageIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.storageQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return List.empty();
    }
    var list = GlobalVariables.getQueryList(result, PartEnum.storage);
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'].toString().startsWith(storageIdFront)) {
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getCoolerGraphQL(String coolingIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.coolingQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return List.empty();
    }
    var list = GlobalVariables.getQueryList(result, PartEnum.cooling);
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'].toString().startsWith(coolingIdFront)) {
        return [list[i]];
      }
    }
    return List.empty();
  }

  Future<List> _getCaseGraphQL(String caseIdFront) async {
    final QueryOptions options = QueryOptions(
      document: gql(Queries.caseQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return List.empty();
    }
    var list = GlobalVariables.getQueryList(result, PartEnum.pcCase);
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'].toString().startsWith(caseIdFront)) {
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
              if (_isError == false)
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
              if (_isError) Container(),
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child:
                          Text(_loadingMessage, style: TextStyles.sourceSans3),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}

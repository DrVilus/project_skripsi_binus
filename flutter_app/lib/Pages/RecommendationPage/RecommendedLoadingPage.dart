import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_skripsi/Pages/BuildSchema/BuildSchemaPage.dart';
import 'package:project_skripsi/UI/Palette.dart';
import 'package:project_skripsi/Variables/Queries.dart';
import 'package:project_skripsi/Variables/RecommendationQueries.dart';

import '../../Models/RecommendationModels.dart';
import '../../Variables/GlobalVariables.dart';
import '../../Variables/GraphQLClient.dart';

class RecommendedLoadingPage extends StatefulWidget {
  const RecommendedLoadingPage({Key? key, required this.targetMarketCode, required this.budget}) : super(key: key);
  final String targetMarketCode;
  final double budget;
  @override
  State<RecommendedLoadingPage> createState() => _RecommendedLoadingPageState();
}

class _RecommendedLoadingPageState extends State<RecommendedLoadingPage> {
  String _loadingMessage = "";
  bool _isError = false;
  List<FullPcPartModel> fullPcPartModelList = [];
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => executeAfterBuild());
  }

  void executeAfterBuild() async {
    setState(() {
      _loadingMessage = "Obtaining CPU Data";
    });
    var cpuList = await _getCpuGraphQL();

    List<String> cpuSockets = [];
    for(int i = 0; i < cpuList.length; i++){
      cpuSockets.add(cpuList[i]['socket_name'].toString());
    }

    setState(() {
      _loadingMessage = "Obtaining Motherboard Data";
    });
    var motherboardList = await _getMotherboardGraphQL(cpuSockets);

    List<CpuMotherboardPair> cpuMotherboardPairList = [];
    for(int i = 0; i < cpuList.length; i++){
      var newData = CpuMotherboardPair(cpuList[i], motherboardList.where((element) => element['cpu_socket'] == cpuList[i]['socket_name']).first);
      cpuMotherboardPairList.add(newData);
    }

    if(cpuMotherboardPairList.isEmpty){
      setState(() {
        _isError = true;
        _loadingMessage = "Budget is too low for current cpu market";
      });
      return;
    }

    setState(() {
      _loadingMessage = "Obtaining GPU Data";
    });
    var gpuList = await _getGpuGraphQL();

    int maxWatt = 0;
    for(int i = 0; i < gpuList.length; i++){
      if(gpuList[i]['recommended_wattage'] > maxWatt){
        maxWatt = gpuList[i]['recommended_wattage'];
      }
    }

    setState(() {
      _loadingMessage = "Obtaining PSU Data";
    });
    var psuList = await _getPsuGraphQL(maxWatt);
    psuList.sort((a, b) => a['power_W'].compareTo(b['power_W']));

    List<GpuPsuPair> gpuPsuPairList = [];
    if(widget.targetMarketCode == "1"){
      gpuPsuPairList.add(GpuPsuPair(null, psuList.where((element) => element['power_W'] >= 300).first));
    }else{
      for(int i = 0; i < gpuList.length; i++){
        var newData = GpuPsuPair(gpuList[i], psuList.where((element) => element['power_W'] >= gpuList[i]['recommended_wattage']).first);
        gpuPsuPairList.add(newData);
      }
    }

    setState(() {
      _loadingMessage = "Obtaining Storage Data";
    });
    var storageList = await _getStorageGraphQL();

    setState(() {
      _loadingMessage = "Obtaining Ram Data";
    });
    var ramList = await _getRamGraphQL();
    int ramCount = 1;
    if(widget.targetMarketCode != "1" ){
      ramCount = 2;
    }

    setState(() {
      _loadingMessage = "Obtaining Cooler Data";
    });
    var coolerList = await _getCoolerGraphQL();

    setState(() {
      _loadingMessage = "Obtaining Case Data";
    });
    List caseList = [];
    var caseListTemp = await _getCaseGraphQL();
    caseListTemp.sort((a, b) => a['case_prices'][0]['price'].compareTo(b['case_prices'][0]['price']));
    caseList.add(caseListTemp[0]);

    setState(() {
      _loadingMessage = "Calculating Possible Combinations";
    });

    Future.delayed(const Duration(milliseconds: 1000), (){
      for (var cpuMotherboardPair in cpuMotherboardPairList) {
        for(var storage in storageList){
          for(var ram in ramList){
            for(var cooler in coolerList){
              for(var pcCase in caseList){
                for(var gpuPsuPair in gpuPsuPairList){
                  FullPcPartModel newData = FullPcPartModel(cpuMotherboardPair, gpuPsuPair, pcCase, storage, ram, ramCount,cooler);
                  if((newData.price <= widget.budget) && (widget.budget-500000 <= newData.price)){
                    fullPcPartModelList.add(newData);
                  }
                }
              }
            }
          }
        }
      }
    }).then((value) {
      fullPcPartModelList.sort((b,a) => a.price.compareTo(b.price));
      setState(() {
        _loadingMessage = "Done";
      });
      print(fullPcPartModelList.length);

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => BuildSchemaPage(fullPcPartModelList: fullPcPartModelList[0]),
        ),
      );
    });

    //descending sort

  }

  Future<List> _getCpuGraphQL() async {
    final QueryOptions options = QueryOptions(
      document: gql(RecommendationQueries.cpuQueryByPrice),
      variables: {
        '_lt': widget.budget/2,
      },
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    return getQueryList(result, PartEnum.cpu);
  }

  Future<List> _getMotherboardGraphQL(List<String> socketList) async {
    final QueryOptions options = QueryOptions(
      document: gql(RecommendationQueries.motherboardQueryBySocket),
      variables: {
        '_in': socketList,
      },
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    return getQueryList(result, PartEnum.motherboard);
  }

  Future<List> _getGpuGraphQL() async {
    final QueryOptions options = QueryOptions(
      document: gql(RecommendationQueries.gpuQueryByPriceAndTargetMarket),
      variables: {
        '_lte': widget.budget/2,
        '_tmneq': widget.targetMarketCode
      },
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    return getQueryList(result, PartEnum.gpu);
  }

  Future<List> _getPsuGraphQL(int maxWatt) async {
    final QueryOptions options = QueryOptions(
      document: gql(RecommendationQueries.psuQueryByWatt),
      variables: {
        '_gte': maxWatt,
      },
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    return getQueryList(result, PartEnum.psu);
  }

  Future<List> _getRamGraphQL() async {
    final QueryOptions options = QueryOptions(
      document: gql(ramQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    return getQueryList(result, PartEnum.ram);
  }

  Future<List> _getStorageGraphQL() async {
    final QueryOptions options = QueryOptions(
      document: gql(storageQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    return getQueryList(result, PartEnum.storage);
  }

  Future<List> _getCoolerGraphQL() async {
    final QueryOptions options = QueryOptions(
      document: gql(coolingQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    return getQueryList(result, PartEnum.cooling);
  }

  Future<List> _getCaseGraphQL() async {
    final QueryOptions options = QueryOptions(
      document: gql(caseQuery),
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }
    return getQueryList(result, PartEnum.pcCase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                  Text(_loadingMessage, style: TextStyles.sourceSans3),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

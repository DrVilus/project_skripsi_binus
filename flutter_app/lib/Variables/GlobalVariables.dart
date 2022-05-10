
library flutter_app.global_variables;

import 'package:graphql_flutter/graphql_flutter.dart';

import '../Models/PartsSelectModel.dart';
import 'Queries.dart';

String currentBuildName = "";

List<PartsSelectModel> partSelectModelList = [
  PartsSelectModel("Case", "assets/img/case.png", 0, "", ""),
  PartsSelectModel("Cooling", "assets/img/cooling.png", 1, coolingQuery, coolingQueryById),
  PartsSelectModel("Motherboard", "assets/img/motherboard.png", 2, motherboardQuery, motherboardQueryById),
  PartsSelectModel("GPU", "assets/img/gpu.png", 3, gpuQuery, gpuQueryById),
  PartsSelectModel("CPU", "assets/img/processor.png", 4, cpuQuery, cpuQueryById),
  PartsSelectModel("PSU", "assets/img/PSU.png", 5, psuQuery, psuQueryById),
  PartsSelectModel("RAM", "assets/img/ramicon.png", 6, ramQuery, ramQueryById),
  PartsSelectModel("Storage", "assets/img/ssd.png", 7, storageQuery, storageQueryById),
];

List getQueryList(QueryResult queryResult, int index){
  switch(index){
    case 1: {
      return queryResult.data?['cooling'];
    }
    case 2: {
      return queryResult.data?['motherboard'];
    }
    case 3: {
      return queryResult.data?['gpu'];
    }
    case 4: {
      return queryResult.data?['cpu'];
    }
    case 5: {
      return queryResult.data?['power_supply'];
    }
    case 6: {
      return queryResult.data?['ram'];
    }
    case 7: {
      return queryResult.data?['storage'];
    }

    default: {
      return [];
    }
  }
}

String getQueryPriceText(int index){
  switch(index){
    case 1: {
      return 'cooling_prices';
    }
    case 2: {
      return 'motherboard_prices';
    }
    case 3: {
      return 'gpu_prices';
    }
    case 4: {
      return 'cpu_prices';
    }
    case 5: {
      return 'power_supply_prices';
    }
    case 6: {
      return 'ram_prices';
    }
    case 7: {
      return 'storage_prices';
    }

    default: {
      return '';
    }
  }
}
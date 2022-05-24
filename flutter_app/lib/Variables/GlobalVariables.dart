
library flutter_app.global_variables;

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../Models/PartsSelectModel.dart';
import 'Queries.dart';

List<PartsSelectModel> partSelectModelList = [
  PartsSelectModel("Case", "assets/img/case.png", PartEnum.pcCase, "", ""),
  PartsSelectModel("Cooling", "assets/img/cooling.png", PartEnum.cooling, coolingQuery, coolingQueryById),
  PartsSelectModel("Motherboard", "assets/img/motherboard.png", PartEnum.motherboard, motherboardQuery, motherboardQueryById),
  PartsSelectModel("GPU", "assets/img/gpu.png", PartEnum.gpu, gpuQuery, gpuQueryById),
  PartsSelectModel("CPU", "assets/img/processor.png", PartEnum.cpu, cpuQuery, cpuQueryById),
  PartsSelectModel("PSU", "assets/img/PSU.png", PartEnum.psu, psuQuery, psuQueryById),
  PartsSelectModel("RAM", "assets/img/ramicon.png", PartEnum.ram, ramQuery, ramQueryById),
  PartsSelectModel("Storage", "assets/img/ssd.png", PartEnum.storage, storageQuery, storageQueryById),
];

enum PartEnum{
  pcCase,
  cooling,
  motherboard,
  gpu,
  cpu,
  psu,
  ram,
  storage,
  others
}

PartEnum convertIndexToEnum(int index){
  switch(index){
    case 1: {
      return PartEnum.cooling;
    }
    case 2: {
      return PartEnum.motherboard;
    }
    case 3: {
      return PartEnum.gpu;
    }
    case 4: {
      return PartEnum.cpu;
    }
    case 5: {
      return PartEnum.psu;
    }
    case 6: {
      return PartEnum.ram;
    }
    case 7: {
      return PartEnum.storage;
    }

    default: {
      return PartEnum.others;
    }
  }
}

List getQueryList(QueryResult queryResult, PartEnum enumInput){
  switch(enumInput){
    case PartEnum.cooling: {
      return queryResult.data?['cooling'];
    }
    case PartEnum.motherboard: {
      return queryResult.data?['motherboard'];
    }
    case PartEnum.gpu: {
      return queryResult.data?['gpu'];
    }
    case PartEnum.cpu: {
      return queryResult.data?['cpu'];
    }
    case PartEnum.psu: {
      return queryResult.data?['power_supply'];
    }
    case PartEnum.ram: {
      return queryResult.data?['ram'];
    }
    case PartEnum.storage: {
      return queryResult.data?['storage'];
    }

    default: {
      return [];
    }
  }
}

String getQueryPriceText(PartEnum enumInput){
  switch(enumInput){
    case PartEnum.cooling: {
      return 'cooling_prices';
    }
    case PartEnum.motherboard: {
      return 'motherboard_prices';
    }
    case PartEnum.gpu: {
      return 'gpu_prices';
    }
    case PartEnum.cpu: {
      return 'cpu_prices';
    }
    case PartEnum.psu: {
      return 'power_supply_prices';
    }
    case PartEnum.ram: {
      return 'ram_prices';
    }
    case PartEnum.storage: {
      return 'storage_prices';
    }

    default: {
      return '';
    }
  }
}
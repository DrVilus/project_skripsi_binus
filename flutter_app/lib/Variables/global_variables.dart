import 'package:graphql_flutter/graphql_flutter.dart';
import '../Models/parts_select_model.dart';
import 'Queries.dart';

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

class GlobalVariables{
  static List<PartsSelectModel> partSelectModelList = [
    PartsSelectModel("Case", "assets/img/case.png", PartEnum.pcCase, Queries.caseQuery, Queries.caseQueryById),
    PartsSelectModel("Cooling", "assets/img/cooling.png", PartEnum.cooling, Queries.coolingQuery, Queries.coolingQueryById),
    PartsSelectModel("Motherboard", "assets/img/motherboard.png", PartEnum.motherboard, Queries.motherboardQuery, Queries.motherboardQueryById),
    PartsSelectModel("GPU", "assets/img/gpu.png", PartEnum.gpu, Queries.gpuQuery, Queries.gpuQueryById),
    PartsSelectModel("CPU", "assets/img/processor.png", PartEnum.cpu, Queries.cpuQuery, Queries.cpuQueryById),
    PartsSelectModel("PSU", "assets/img/PSU.png", PartEnum.psu, Queries.psuQuery, Queries.psuQueryById),
    PartsSelectModel("RAM", "assets/img/ramicon.png", PartEnum.ram, Queries.ramQuery, Queries.ramQueryById),
    PartsSelectModel("Storage", "assets/img/ssd.png", PartEnum.storage, Queries.storageQuery, Queries.storageQueryById),
  ];



  static PartEnum convertIndexToEnum(int index){
    switch(index){
      case 0:{
        return PartEnum.pcCase;
      }
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

  static List getQueryList(QueryResult queryResult, PartEnum enumInput){
    switch(enumInput){
      case PartEnum.pcCase: {
        if(queryResult.data!['case'] == null){
          return List.empty();
        }
        return queryResult.data!['case'];
      }

      case PartEnum.cooling: {
        if(queryResult.data!['cooling'] == null){
          return List.empty();
        }
        return queryResult.data!['cooling'];
      }

      case PartEnum.motherboard: {
        if(queryResult.data!['motherboard'] == null){
          return List.empty();
        }
        return queryResult.data!['motherboard'];
      }

      case PartEnum.gpu: {
        if(queryResult.data!['gpu'] == null){
          return List.empty();
        }
        return queryResult.data!['gpu'];
      }
      case PartEnum.cpu: {
        if(queryResult.data!['cpu'] == null){
          return List.empty();
        }
        return queryResult.data!['cpu'];
      }
      case PartEnum.psu: {
        if(queryResult.data!['power_supply'] == null){
          return List.empty();
        }
        return queryResult.data!['power_supply'];
      }
      case PartEnum.ram: {
        if(queryResult.data!['ram'] == null){
          return List.empty();
        }
        return queryResult.data!['ram'];
      }
      case PartEnum.storage: {
        if(queryResult.data!['storage'] == null){
          return List.empty();
        }
        return queryResult.data!['storage'];
      }

      default: {
        return List.empty();
      }
    }
  }

  static String getQueryPriceText(PartEnum enumInput){
    switch(enumInput){
      case PartEnum.pcCase: {
        return 'case_prices';
      }
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
}


import '../Variables/global_variables.dart';

class CpuMotherboardPair{
  late Map<String, dynamic>? cpuData;
  late Map<String, dynamic>? motherboardData;
  num price = 0;

  CpuMotherboardPair(Map<String, dynamic>? cpuInput, Map<String, dynamic>? motherboardInput){
    cpuData = cpuInput;
    motherboardData = motherboardInput;

    if(cpuInput != null){
      price += cpuInput[GlobalVariables.getQueryPriceText(PartEnum.cpu)][0]['price'];
    }
    if(motherboardInput != null){
      price += motherboardInput[GlobalVariables.getQueryPriceText(PartEnum.motherboard)][0]['price'];
    }

  }
}

class GpuPsuPair{
  late Map<String, dynamic>? gpuData;
  late Map<String, dynamic>? psuData;
  num price = 0;

  GpuPsuPair(Map<String, dynamic>? gpuInput, Map<String, dynamic>? psuInput){
    gpuData = gpuInput;
    psuData = psuInput;

    if(psuInput != null){
      price += psuInput[GlobalVariables.getQueryPriceText(PartEnum.psu)][0]['price'];
    }
    if(gpuInput != null){
      price += gpuInput[GlobalVariables.getQueryPriceText(PartEnum.gpu)][0]['price'];
    }
  }
}

class FullPcPartModel{
  late CpuMotherboardPair cpuMotherboardPair;
  late GpuPsuPair gpuPsuPair;
  late Map<String, dynamic>? storageData;
  late Map<String, dynamic>? ramData;
  late int ramCount;
  late Map<String, dynamic>? coolerData;
  late Map<String, dynamic>? caseData;
  num price = 0;

  FullPcPartModel(
      CpuMotherboardPair cpuMotherboardPairInput,
      GpuPsuPair gpuPsuPairInput,
      Map<String, dynamic>? caseInput,
      Map<String, dynamic>? storageInput,
      Map<String, dynamic>? ramInput,
      int ramCountInput,
      Map<String, dynamic>? coolerInput,
  ){
    cpuMotherboardPair = cpuMotherboardPairInput;
    caseData = caseInput;
    gpuPsuPair = gpuPsuPairInput;
    storageData = storageInput;
    ramData = ramInput;
    ramCount = ramCountInput;
    coolerData = coolerInput;
    price = cpuMotherboardPairInput.price +
        gpuPsuPairInput.price;

    if(caseInput != null){
      price += caseInput[GlobalVariables.getQueryPriceText(PartEnum.pcCase)][0]['price'];
    }
    if(storageInput != null){
      price += storageInput[GlobalVariables.getQueryPriceText(PartEnum.storage)][0]['price'];
    }
    if(ramInput != null){
      price += (ramInput[GlobalVariables.getQueryPriceText(PartEnum.ram)][0]['price'] * ramCountInput);
    }
    if(coolerInput != null){
      price += coolerInput[GlobalVariables.getQueryPriceText(PartEnum.cooling)][0]['price'];
    }
  }
}
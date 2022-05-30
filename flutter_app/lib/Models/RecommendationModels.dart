import '../Variables/GlobalVariables.dart';

class CpuMotherboardPair{
  late Map<String, dynamic> cpuData;
  late Map<String, dynamic> motherboardData;
  double price = 0;

  CpuMotherboardPair(Map<String, dynamic> cpuInput, Map<String, dynamic> motherboardInput){
    cpuData = cpuInput;
    motherboardData = motherboardInput;
    price = cpuInput[getQueryPriceText(PartEnum.cpu)][0]['price'] + motherboardInput[getQueryPriceText(PartEnum.motherboard)][0]['price'];
  }
}

class GpuPsuPair{
  late Map<String, dynamic>? gpuData;
  late Map<String, dynamic> psuData;
  double price = 0;

  GpuPsuPair(Map<String, dynamic>? gpuInput, Map<String, dynamic> psuInput){
    if(gpuInput == null){
      gpuData = null;
      psuData = psuInput;
      price = psuInput[getQueryPriceText(PartEnum.psu)][0]['price'];
    }else{
      gpuData = gpuInput;
      psuData = psuInput;
      price = gpuInput[getQueryPriceText(PartEnum.gpu)][0]['price'] + psuInput[getQueryPriceText(PartEnum.psu)][0]['price'];
    }
  }
}

class FullPcPartModel{
  late CpuMotherboardPair cpuMotherboardPair;
  late GpuPsuPair gpuPsuPair;
  late Map<String, dynamic> storageData;
  late Map<String, dynamic> ramData;
  late int ramCount;
  late Map<String, dynamic> coolerData;
  late Map<String, dynamic> caseData;
  double price = 0;

  FullPcPartModel(
      CpuMotherboardPair cpuMotherboardPairInput,
      GpuPsuPair gpuPsuPairInput,
      Map<String, dynamic> caseInput,
      Map<String, dynamic> storageInput,
      Map<String, dynamic> ramInput,
      int ramCountInput,
      Map<String, dynamic> coolerInput,
  ){
    cpuMotherboardPair = cpuMotherboardPairInput;
    caseData = caseInput;
    gpuPsuPair = gpuPsuPairInput;
    storageData = storageInput;
    ramData = ramInput;
    ramCount = ramCountInput;
    coolerData = coolerInput;
    price = cpuMotherboardPairInput.price +
        gpuPsuPairInput.price +
        caseInput[getQueryPriceText(PartEnum.pcCase)][0]['price'] +
        storageInput[getQueryPriceText(PartEnum.storage)][0]['price'] +
        (ramInput[getQueryPriceText(PartEnum.ram)][0]['price'] * ramCountInput) +
        coolerInput[getQueryPriceText(PartEnum.cooling)][0]['price'];
  }
}
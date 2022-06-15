import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:project_skripsi/Variables/GlobalVariables.dart';

import '../../Functions/CompatibilityCheckFunctions.dart';

class BuildSchemaStateModel extends ChangeNotifier {

  //0 = ChoosePartsWidget
  //1 = ChoosePartsModelWidget
  //2 = PartsInfoWidget
  int _currentSidebarState = 0;
  int get sidebarState => _currentSidebarState;
  void changeSidebarState(int input){
    _currentSidebarState = input;
    notifyListeners();
  }

  bool _currentSidebarToggle = false;
  bool get sidebarToggle => _currentSidebarToggle;
  void changeSidebarToggle(){
    _currentSidebarToggle = !_currentSidebarToggle;
    notifyListeners();
  }

  bool _currentEstimatedPriceWidgetToggle = false;
  bool get estimatedPriceWidgetToggle => _currentEstimatedPriceWidgetToggle;
  void changeEstimatedPriceWidgetToggle(){
    _currentEstimatedPriceWidgetToggle = !_currentEstimatedPriceWidgetToggle;
    notifyListeners();
  }

  //refer to partSelectModelList in global variables
  PartEnum _currentSelectedPartEnum = PartEnum.others;
  PartEnum get selectedPartEnum => _currentSelectedPartEnum;
  void changeSelectedPartEnum(PartEnum input){
    _currentSelectedPartEnum = input;
    //notifyListeners();
  }

  String _currentSelectedPartModelId = '';
  String get selectedPartModelId => _currentSelectedPartModelId;
  void changeSelectedPartModelId(String input){
    _currentSelectedPartModelId = input;
  }

  //For PC Build Name
  final TextEditingController _textEditingController = TextEditingController(text: "PC Build #1");
  TextEditingController get textEditingController => _textEditingController;
  void changeBuildName(String input){
    textEditingController.text = input;
  }

  //Data for selected Parts
  //mb
  final List _currentSelectedMotherboard = [];
  List get selectedMotherboard => _currentSelectedMotherboard;
  String changeSelectedMotherboard(List query){
    if(selectedCPU.isNotEmpty){
      if(selectedCPU[0]['socket_name'] != query[0]['cpu_socket']){
        return ('Incompatible cpu socket. cpu has ' + selectedCPU[0]['socket_name'] + ' while motherboard has ' + query[0]['cpu_socket']);
      }
    }
    _currentSelectedMotherboard.clear();
    _currentSelectedMotherboard.add(query[0]);
    notifyListeners();
    return '';
  }

  void clearSelectedMotherboard(){
    _currentSelectedMotherboard.clear();
    notifyListeners();
  }

  //cpu
  final List _currentSelectedCPU = [];
  List get selectedCPU => _currentSelectedCPU;
  String changeSelectedCPU(List query){
    if(selectedMotherboard.isNotEmpty){
      if(query[0]['socket_name'] != selectedMotherboard[0]['cpu_socket']){
        return ('Incompatible cpu socket. Cpu has ' + query[0]['socket_name'] + ' while motherboard has ' + selectedMotherboard[0]['cpu_socket']);
      }
    }
    _currentSelectedCPU.clear();
    _currentSelectedCPU.add(query[0]);
    notifyListeners();
    return '';
  }

  void clearSelectedCPU(){
    _currentSelectedCPU.clear();
    notifyListeners();
  }

  //gpu
  final List _currentSelectedGPU = [];
  List get selectedGPU => _currentSelectedGPU;
  String changeSelectedGPU(List query){
    if(_currentSelectedMotherboard.isNotEmpty){
      Map<String,dynamic> serializedJson = jsonDecode(_currentSelectedMotherboard[0]['pcie_slots_json']);
      if(CompatibilityCheckFunctions().handlePcieCompatibilityWithJson(query[0]['interface_bus'], serializedJson) == false){
        return ('Incompatible PCIE Slot. Gpu needs a ' + query[0]['interface_bus'] + ' slot');
      }
    }
    if(_currentSelectedPSU.isNotEmpty){
      if(query[0]['recommended_wattage'] > _currentSelectedPSU[0]['power_W']){
        return('Not enough Power, needs at least ' + query[0]['recommended_wattage'].toString() + 'W for the selected hardware.');
      }
    }
    _currentSelectedGPU.clear();
    _currentSelectedGPU.add(query[0]);
    notifyListeners();
    return '';
  }

  void clearSelectedGPU(){
    _currentSelectedGPU.clear();
    notifyListeners();
  }

  //ram
  final List _currentSelectedRAM = [];
  List get selectedRAM => _currentSelectedRAM;
  int currentSelectedRAMCount = 0;
  String changeSelectedRAM(List query){
    _currentSelectedRAM.clear();
    _currentSelectedRAM.add(query[0]);
    notifyListeners();
    return '';
  }

  void clearSelectedRAM(){
    _currentSelectedRAM.clear();
    notifyListeners();
  }

  void changeSelectedRAMCount(int ramCountInput){
    currentSelectedRAMCount = ramCountInput;
    notifyListeners();
  }

  //psu
  final List _currentSelectedPSU = [];
  List get selectedPSU => _currentSelectedPSU;
  String changeSelectedPSU(List query){
    if(_currentSelectedGPU.isNotEmpty){
      if(_currentSelectedGPU[0]['recommended_wattage'] > query[0]['power_W']){
        return('Not enough Power, needs at least ' + _currentSelectedGPU[0]['recommended_wattage'].toString() + 'W for the selected hardware.');
      }
    }
    _currentSelectedPSU.clear();
    _currentSelectedPSU.add(query[0]);
    notifyListeners();
    return '';
  }

  void clearSelectedPSU(){
    _currentSelectedPSU.clear();
    notifyListeners();
  }

  //cooler
  final List _currentSelectedCooler = [];
  List get selectedCooler => _currentSelectedCooler;
  String changeSelectedCooler(List query){
    _currentSelectedCooler.clear();
    _currentSelectedCooler.add(query[0]);
    notifyListeners();
    return '';
  }

  void clearSelectedCooler(){
    _currentSelectedCooler.clear();
    notifyListeners();
  }

  //storage
  final List _currentSelectedStorage = [];
  List get selectedStorage => _currentSelectedStorage;
  String changeSelectedStorage(List query){
    _currentSelectedStorage.clear();
    _currentSelectedStorage.add(query[0]);
    notifyListeners();
    return '';
  }

  void clearSelectedStorage(){
    _currentSelectedStorage.clear();
    notifyListeners();
  }

  //case
  final List _currentSelectedCase = [];
  List get selectedCase => _currentSelectedCase;
  String changeSelectedCase(List query){
    _currentSelectedCase.clear();
    _currentSelectedCase.add(query[0]);
    notifyListeners();
    return '';
  }

  void clearSelectedCase(){
    _currentSelectedCase.clear();
    notifyListeners();
  }

  ///Change Part by checking its query content and enum, return empty string if success. Returns an error if fails.
  String changePart(List query, PartEnum partEnum){
    switch(partEnum){
      case PartEnum.pcCase: {
        return changeSelectedCase(query);
      }
      case PartEnum.cooling: {
        return changeSelectedCooler(query);
      }
      case PartEnum.motherboard: {
        return changeSelectedMotherboard(query);
      }
      case PartEnum.gpu: {
        return changeSelectedGPU(query);
      }
      case PartEnum.cpu: {
        return changeSelectedCPU(query);
      }
      case PartEnum.psu: {
        return changeSelectedPSU(query);
      }
      case PartEnum.ram: {
        return changeSelectedRAM(query);
      }
      case PartEnum.storage: {
        return changeSelectedStorage(query);
      }
      default: {
        return 'error default';
      }
    }
  }

  void removePart(PartEnum partEnum){
    switch(partEnum){
      case PartEnum.pcCase: {
        if(selectedCase.isNotEmpty){
          clearSelectedCase();
        }
        break;
      }
      case PartEnum.cooling: {
        if(selectedCooler.isNotEmpty){
          clearSelectedCooler();
        }
        break;
      }
      case PartEnum.motherboard: {
        if(selectedMotherboard.isNotEmpty){
          clearSelectedMotherboard();
        }
        break;
      }
      case PartEnum.gpu: {
        if(selectedGPU.isNotEmpty){
          clearSelectedGPU();
        }
        break;
      }
      case PartEnum.cpu: {
        if(selectedCPU.isNotEmpty){
          clearSelectedCPU();
        }
        break;
      }
      case PartEnum.psu: {
        if(selectedPSU.isNotEmpty){
          clearSelectedPSU();
        }
        break;
      }
      case PartEnum.ram: {
        if(selectedRAM.isNotEmpty){
          clearSelectedRAM();
        }
        break;
      }
      case PartEnum.storage: {
        if(selectedStorage.isNotEmpty){
          clearSelectedStorage();
        }
        break;
      }

      default: {
        break;
      }
    }
  }

  ///Return as ID of the selected part
  String checkPartChosenId(PartEnum partEnum){
    switch(partEnum){
      case PartEnum.pcCase: {
        if(selectedCase.isNotEmpty){
          return selectedCase[0]['id'];
        }
        return '';
      }
      case PartEnum.cooling: {
        if(selectedCooler.isNotEmpty){
          return selectedCooler[0]['id'];
        }
        return '';
      }
      case PartEnum.motherboard: {
        if(selectedMotherboard.isNotEmpty){
          return selectedMotherboard[0]['id'];
        }else {
          return '';
        }
      }
      case PartEnum.gpu: {
        if(selectedGPU.isNotEmpty){
          return selectedGPU[0]['id'];
        }else {
          return '';
        }
      }
      case PartEnum.cpu: {
        if(selectedCPU.isNotEmpty){
          return selectedCPU[0]['id'];
        }else {
          return '';
        }
      }
      case PartEnum.psu: {
        if(selectedPSU.isNotEmpty){
          return selectedPSU[0]['id'];
        }else {
          return '';
        }
      }
      case PartEnum.ram: {
        if(selectedRAM.isNotEmpty){
          return selectedRAM[0]['id'];
        }else {
          return '';
        }
      }
      case PartEnum.storage: {
        if(selectedStorage.isNotEmpty){
          return selectedStorage[0]['id'];
        }else {
          return '';
        }
      }

      default: {
        return '';
      }
    }
  }

  ///Return as Name of the selected part
  String checkPartChosenName(PartEnum partEnum){
    switch(partEnum){
      case PartEnum.pcCase: {
        if(selectedCase.isNotEmpty){
          return selectedCase[0]['name'];
        }
        return '';
      }
      case PartEnum.cooling: {
        if(selectedCooler.isNotEmpty){
          return selectedCooler[0]['name'];
        }
        return '';
      }
      case PartEnum.motherboard: {
        if(selectedMotherboard.isNotEmpty){
          return selectedMotherboard[0]['name'];
        }else {
          return '';
        }
      }
      case PartEnum.gpu: {
        if(selectedGPU.isNotEmpty){
          return selectedGPU[0]['name'];
        }else {
          return '';
        }
      }
      case PartEnum.cpu: {
        if(selectedCPU.isNotEmpty){
          return selectedCPU[0]['name'];
        }else {
          return '';
        }
      }
      case PartEnum.psu: {
        if(selectedPSU.isNotEmpty){
          return selectedPSU[0]['name'];
        }else {
          return '';
        }
      }
      case PartEnum.ram: {
        if(selectedRAM.isNotEmpty){
          return selectedRAM[0]['name'];
        }else {
          return '';
        }
      }
      case PartEnum.storage: {
        if(selectedStorage.isNotEmpty){
          return selectedStorage[0]['name'];
        }else {
          return '';
        }
      }

      default: {
        return '';
      }
    }
  }

  double calculatePrice(){
    double initPrice = 0;
    if(selectedCooler.isNotEmpty){
      initPrice += selectedCooler[0]['cooling_prices'][0]['price'];
    }
    if(selectedGPU.isNotEmpty){
      initPrice += selectedGPU[0]['gpu_prices'][0]['price'];
    }
    if(selectedCPU.isNotEmpty){
      initPrice += selectedCPU[0]['cpu_prices'][0]['price'];
    }
    if(selectedMotherboard.isNotEmpty){
      initPrice += selectedMotherboard[0]['motherboard_prices'][0]['price'];
    }
    if(selectedPSU.isNotEmpty){
      initPrice += selectedPSU[0]['power_supply_prices'][0]['price'];
    }
    if(selectedRAM.isNotEmpty){
      initPrice += selectedRAM[0]['ram_prices'][0]['price'] * currentSelectedRAMCount;
    }
    if(selectedStorage.isNotEmpty){
      initPrice += selectedStorage[0]['storage_prices'][0]['price'];
    }
    if(selectedCase.isNotEmpty){
      initPrice += selectedCase[0]['case_prices'][0]['price'];
    }

    return initPrice;
  }

}
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:project_skripsi/Variables/GlobalVariables.dart';

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
  void changeSelectedMotherboard(List query){
    _currentSelectedMotherboard.clear();
    _currentSelectedMotherboard.add(query[0]);
    notifyListeners();
  }

  //cpu
  final List _currentSelectedCPU = [];
  List get selectedCPU => _currentSelectedCPU;
  void changeSelectedCPU(List query){
    _currentSelectedCPU.clear();
    _currentSelectedCPU.add(query[0]);
    notifyListeners();
  }

  //gpu
  final List _currentSelectedGPU = [];
  List get selectedGPU => _currentSelectedGPU;
  void changeSelectedGPU(List query){
    _currentSelectedGPU.clear();
    _currentSelectedGPU.add(query[0]);
    notifyListeners();
  }

  //ram
  final List _currentSelectedRAM = [];
  List get selectedRAM => _currentSelectedRAM;
  void changeSelectedRAM(List query){
    _currentSelectedRAM.clear();
    _currentSelectedRAM.add(query[0]);
    notifyListeners();
  }

  //psu
  List selectedPSU = [];
  void changeSelectedPSU(List query){
    selectedPSU = query;
    notifyListeners();
  }

  //cooler
  final List _currentSelectedCooler = [];
  List get selectedCooler => _currentSelectedCooler;
  void changeSelectedCooler(List query){
    _currentSelectedCooler.clear();
    _currentSelectedCooler.add(query[0]);
    notifyListeners();
  }

  //storage
  final List _currentSelectedStorage = [];
  List get selectedStorage => _currentSelectedStorage;
  void changeSelectedStorage(List query){
    _currentSelectedStorage.clear();
    _currentSelectedStorage.add(query[0]);
    notifyListeners();
  }

  void changePart(List query, PartEnum partEnum){
    switch(partEnum){
      case PartEnum.cooling: {
        changeSelectedCooler(query);
        break;
      }
      case PartEnum.motherboard: {
        changeSelectedMotherboard(query);
        break;
      }
      case PartEnum.gpu: {
        changeSelectedGPU(query);
        break;
      }
      case PartEnum.cpu: {
        changeSelectedCPU(query);
        break;
      }
      case PartEnum.psu: {
        changeSelectedPSU(query);
        break;
      }
      case PartEnum.ram: {
        changeSelectedRAM(query);
        break;
      }
      case PartEnum.storage: {
        changeSelectedStorage(query);
        break;
      }

      default: {
        break;
      }
    }
    notifyListeners();
  }
}
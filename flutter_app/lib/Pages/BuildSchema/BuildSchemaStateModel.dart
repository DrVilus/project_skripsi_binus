import 'dart:core';
import 'package:flutter/cupertino.dart';

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
  int _currentSelectedPartIndex = 0;
  int get selectedPartIndex => _currentSelectedPartIndex;
  void changeSelectedPartIndex(int input){
    _currentSelectedPartIndex = input;
    //notifyListeners();
  }

  String _currentSelectedPartModelId = '';
  String get selectedPartModelId => _currentSelectedPartModelId;
  void changeSelectedPartModelId(String input){
    _currentSelectedPartModelId = input;
  }

  final TextEditingController _textEditingController = TextEditingController(text: "PC Build #1");
  TextEditingController get textEditingController => _textEditingController;
  void changeBuildName(String input){
    textEditingController.text = input;
  }
}
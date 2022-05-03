library flutter_app.global_variables;

import '../Models/PartsSelectModel.dart';

String currentBuildName = "";

List<PartsSelectModel> partSelectModelList = [
  PartsSelectModel("Case", "assets/img/case.png", 0),
  PartsSelectModel("Cooling", "assets/img/cooling.png", 1),
  PartsSelectModel("Motherboard", "assets/img/motherboard.png", 2),
  PartsSelectModel("GPU", "assets/img/gpu.png", 3),
  PartsSelectModel("CPU", "assets/img/processor.png", 4),
  PartsSelectModel("PSU", "assets/img/PSU.png", 5),
  PartsSelectModel("RAM", "assets/img/ramicon.png", 6),
  PartsSelectModel("Storage", "assets/img/ssd.png", 7),
];
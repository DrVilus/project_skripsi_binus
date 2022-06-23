import 'package:flutter/material.dart';
import 'package:project_skripsi/Pages/BuildSchema/build_schema_state_model.dart';
import 'package:project_skripsi/Pages/BuildSchema/estimated_price_widget.dart';
import 'package:project_skripsi/UI/fade_black_background.dart';
import 'package:project_skripsi/Variables/global_variables.dart';
import 'package:provider/provider.dart';

import '../../Models/recommendation_models.dart';
import '../../UI/custom_app_bar.dart';

class BuildSchemaPage extends StatefulWidget {
  const BuildSchemaPage({Key? key, this.fullPcPartModelList}) : super(key: key);

  final FullPcPartModel? fullPcPartModelList;

  @override
  State<BuildSchemaPage> createState() => _BuildSchemaPageState();
}

class _BuildSchemaPageState extends State<BuildSchemaPage> {
  BuildSchemaStateModel buildSchemaStateModel = BuildSchemaStateModel();

  void _goToPartInfoPage(
      BuildSchemaStateModel stateModel, PartEnum partEnum, String id) {
    stateModel.changeSelectedPartEnum(partEnum);
    stateModel.changeSelectedPartModelId(id);
    stateModel.changeSidebarState(2);
  }

  void _goToPartModelListPage(
      BuildSchemaStateModel stateModel, PartEnum partEnum) {
    stateModel.changeSelectedPartEnum(partEnum);
    stateModel.changeSidebarState(1);
  }

  final ColorFilter disabledColor =
      ColorFilter.mode(Colors.grey.shade800, BlendMode.modulate);
  final ColorFilter enabledColor =
      const ColorFilter.mode(Colors.white, BlendMode.modulate);

  ///Transform data from recommendation or import into schema
  @override
  void initState() {
    super.initState();
    if (widget.fullPcPartModelList != null) {
      if (widget.fullPcPartModelList!.cpuMotherboardPair.cpuData != null) {
        buildSchemaStateModel.changeSelectedCPU(
            [widget.fullPcPartModelList!.cpuMotherboardPair.cpuData]);
      }
      if (widget.fullPcPartModelList!.cpuMotherboardPair.motherboardData !=
          null) {
        buildSchemaStateModel.changeSelectedMotherboard(
            [widget.fullPcPartModelList!.cpuMotherboardPair.motherboardData]);
      }
      if (widget.fullPcPartModelList!.gpuPsuPair.gpuData != null) {
        buildSchemaStateModel.changeSelectedGPU(
            [widget.fullPcPartModelList!.gpuPsuPair.gpuData]);
      }
      if (widget.fullPcPartModelList!.gpuPsuPair.psuData != null) {
        buildSchemaStateModel.changeSelectedPSU(
            [widget.fullPcPartModelList!.gpuPsuPair.psuData]);
      }
      if (widget.fullPcPartModelList!.ramData != null) {
        buildSchemaStateModel
            .changeSelectedRAM([widget.fullPcPartModelList!.ramData]);
      }
      buildSchemaStateModel
          .changeSelectedRAMCount(widget.fullPcPartModelList!.ramCount);

      if (widget.fullPcPartModelList!.storageData != null) {
        buildSchemaStateModel
            .changeSelectedStorage([widget.fullPcPartModelList!.storageData]);
      }
      if (widget.fullPcPartModelList!.coolerData != null) {
        buildSchemaStateModel
            .changeSelectedCooler([widget.fullPcPartModelList!.coolerData]);
      }
      if (widget.fullPcPartModelList!.caseData != null) {
        buildSchemaStateModel
            .changeSelectedCase([widget.fullPcPartModelList!.caseData]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ChangeNotifierProvider.value(
      value: buildSchemaStateModel,
      child: CustomAppbar(
        isExportDisabled: false,
        isTextFieldEnabled: true,
        sideBarVisible: true,
        children: [
          Container(),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.3,
              child: Consumer<BuildSchemaStateModel>(
                  builder: (context, value, child) => ColorFiltered(
                    colorFilter: value.selectedCase.isNotEmpty
                        ? enabledColor
                        : disabledColor,
                    child: Image.asset(
                      'assets/img/caseBack.png',
                      fit: BoxFit.fill, // Fixes border issues
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.width * 0.75,
                    ),
                  ))),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.2,
              child: Consumer<BuildSchemaStateModel>(
                  builder: (context, value, child) => GestureDetector(
                      onTap: () {
                        if (value.selectedCase.isNotEmpty) {
                          value.changeSidebarToggle();
                          _goToPartInfoPage(value, PartEnum.pcCase,
                              value.selectedCase[0]['id']);
                        } else {
                          value.changeSidebarToggle();
                          _goToPartModelListPage(value, PartEnum.pcCase);
                        }
                      }, // Image tapped
                      child: ColorFiltered(
                        colorFilter: value.selectedCase.isNotEmpty
                            ? enabledColor
                            : disabledColor,
                        child: Image.asset(
                          'assets/img/caseSide.png',
                          fit: BoxFit.fill, // Fixes border issues
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.96,
                        ),
                      )))),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Consumer<BuildSchemaStateModel>(
                  builder: (context, value, child) => GestureDetector(
                      onTap: () {
                        if (value.selectedMotherboard.isNotEmpty) {
                          value.changeSidebarToggle();
                          _goToPartInfoPage(value, PartEnum.motherboard,
                              value.selectedMotherboard[0]['id']);
                        } else {
                          value.changeSidebarToggle();
                          _goToPartModelListPage(value, PartEnum.motherboard);
                        }
                      }, // Image tapped
                      child: ColorFiltered(
                        colorFilter: value.selectedMotherboard.isNotEmpty
                            ? enabledColor
                            : disabledColor,
                        child: Image.asset(
                          'assets/img/motherboard2.png',
                          fit: BoxFit.fill, // Fixes border issues
                          width: MediaQuery.of(context).size.width * 0.88 * 0.4,
                          height: MediaQuery.of(context).size.width * 0.49 * 0.4,
                        ),
                      )))),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.21,
              left: MediaQuery.of(context).size.width * 0.6,
              child: Consumer<BuildSchemaStateModel>(
                  builder: (context, value, child) => GestureDetector(
                      onTap: () {
                        if (value.selectedPSU.isNotEmpty) {
                          value.changeSidebarToggle();
                          _goToPartInfoPage(
                              value, PartEnum.psu, value.selectedPSU[0]['id']);
                        } else {
                          value.changeSidebarToggle();
                          _goToPartModelListPage(value, PartEnum.psu);
                        }
                      }, // Image tapped
                      child: ColorFiltered(
                        colorFilter: value.selectedPSU.isNotEmpty
                            ? enabledColor
                            : disabledColor,
                        child: Image.asset(
                          'assets/img/psu2.png',
                          fit: BoxFit.fill, // Fixes border issues
                          width: MediaQuery.of(context).size.width * 0.637 * 0.3,
                          height: MediaQuery.of(context).size.width * 0.463 * 0.3,
                        ),
                      )))),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.43,
              left: MediaQuery.of(context).size.width * 0.32,
              child: Consumer<BuildSchemaStateModel>(
                  builder: (context, value, child) => GestureDetector(
                      onTap: () {
                        if (value.selectedCooler.isNotEmpty) {
                          value.changeSidebarToggle();
                          _goToPartInfoPage(value, PartEnum.cooling,
                              value.selectedCooler[0]['id']);
                        } else {
                          value.changeSidebarToggle();
                          _goToPartModelListPage(value, PartEnum.cooling);
                        }
                      }, // Image tapped
                      child: ColorFiltered(
                        colorFilter: value.selectedCooler.isNotEmpty
                            ? enabledColor
                            : disabledColor,
                        child: Image.asset(
                          'assets/img/cooling2.png',
                          fit: BoxFit.fill, // Fixes border issues
                          width: MediaQuery.of(context).size.width * 0.25 * 0.51,
                          height:
                              MediaQuery.of(context).size.width * 0.25 * 0.51,
                        ),
                      )))),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.6,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Consumer<BuildSchemaStateModel>(
                  builder: (context, value, child) => GestureDetector(
                      onTap: () {
                        if (value.selectedGPU.isNotEmpty) {
                          value.changeSidebarToggle();
                          _goToPartInfoPage(
                              value, PartEnum.gpu, value.selectedGPU[0]['id']);
                        } else {
                          value.changeSidebarToggle();
                          _goToPartModelListPage(value, PartEnum.gpu);
                        }
                      }, // Image tapped
                      child: ColorFiltered(
                        colorFilter: value.selectedGPU.isNotEmpty
                            ? enabledColor
                            : disabledColor,
                        child: Image.asset(
                          'assets/img/gpu2.png',
                          fit: BoxFit.fill, // Fixes border issues
                          width: MediaQuery.of(context).size.width * 0.647 * 0.4,
                          height: MediaQuery.of(context).size.width * 0.258 * 0.4,
                        ),
                      )))),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.33,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Consumer<BuildSchemaStateModel>(
                  builder: (context, value, child) => GestureDetector(
                      onTap: () {
                        if (value.selectedRAM.isNotEmpty) {
                          value.changeSidebarToggle();
                          _goToPartInfoPage(
                              value, PartEnum.ram, value.selectedRAM[0]['id']);
                        } else {
                          value.changeSidebarToggle();
                          _goToPartModelListPage(value, PartEnum.ram);
                        }
                      }, // Image tapped
                      child: ColorFiltered(
                        colorFilter: value.selectedRAM.isNotEmpty
                            ? enabledColor
                            : disabledColor,
                        child: Image.asset(
                          'assets/img/ram.png',
                          fit: BoxFit.fill, // Fixes border issues
                          width:
                              MediaQuery.of(context).size.width * 0.544 * 0.5,
                          height: MediaQuery.of(context).size.width * 0.117 * 0.5,
                        ),
                      )))),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.58,
              left: MediaQuery.of(context).size.width * 0.8,
              child: Consumer<BuildSchemaStateModel>(
                  builder: (context, value, child) => GestureDetector(
                      onTap: () {
                        if (value.selectedStorage.isNotEmpty) {
                          value.changeSidebarToggle();
                          _goToPartInfoPage(value, PartEnum.storage,
                              value.selectedStorage[0]['id']);
                        } else {
                          value.changeSidebarToggle();
                          _goToPartModelListPage(value, PartEnum.storage);
                        }
                      }, // Image tapped
                      child: ColorFiltered(
                        colorFilter: value.selectedStorage.isNotEmpty
                            ? enabledColor
                            : disabledColor,
                        child: Image.asset(
                          'assets/img/storage2.png',
                          fit: BoxFit.fill, // Fixes border issues
                          width: MediaQuery.of(context).size.width * 0.205 *0.4,
                          height:
                              MediaQuery.of(context).size.width * 0.353 * 0.4,
                        ),
                      )))),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.33,
              left: MediaQuery.of(context).size.width * 0.8,
              child: Consumer<BuildSchemaStateModel>(
                  builder: (context, value, child) => GestureDetector(
                      onTap: () {
                        if (value.selectedCPU.isNotEmpty) {
                          value.changeSidebarToggle();
                          _goToPartInfoPage(
                              value, PartEnum.cpu, value.selectedCPU[0]['id']);
                        } else {
                          value.changeSidebarToggle();
                          _goToPartModelListPage(value, PartEnum.cpu);
                        }
                      }, // Image tapped
                      child: ColorFiltered(
                        colorFilter: value.selectedCPU.isNotEmpty
                            ? enabledColor
                            : disabledColor,
                        child: Image.asset(
                          'assets/img/processor2.png',
                          fit: BoxFit.fill, // Fixes border issues
                          width: MediaQuery.of(context).size.width * 0.161 * 0.6,
                          height:
                              MediaQuery.of(context).size.width * 0.112 * 0.6,
                        ),
                      )))),
          Consumer<BuildSchemaStateModel>(
            builder: (context, value, child) => GestureDetector(
              onTap: () {
                value.changeEstimatedPriceWidgetToggle();
              },
              child: FadeBlackBackground(
                  toggleVariable: value.estimatedPriceWidgetToggle),
            ),
          ),
          const EstimatedPriceWidget()
        ],
      ),
    )));
  }
}

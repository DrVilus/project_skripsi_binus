import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_skripsi/Functions/generic_ui_functions.dart';
import 'package:project_skripsi/UI/titled_container.dart';

import '../../UI/custom_app_bar_back.dart';
import '../../UI/palette.dart';
import '../BuildSchema/build_schema_state_model.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({Key? key, required this.buildSchemaStateModel})
      : super(key: key);

  final BuildSchemaStateModel buildSchemaStateModel;

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  var txt = TextEditingController();

  void generateExportCode() {
    String caseId = "0";
    String coolingId = "0";
    String motherboardId = "0";
    String gpuId = "0";
    String cpuId = "0";
    String psuId = "0";
    String ramId = "0";
    String ramCount = "0";
    String storageId = "0";

    if (widget.buildSchemaStateModel.selectedCase.isNotEmpty) {
      caseId =
          widget.buildSchemaStateModel.selectedCase[0]['id'].substring(0, 7);
    }
    if (widget.buildSchemaStateModel.selectedCooler.isNotEmpty) {
      coolingId =
          widget.buildSchemaStateModel.selectedCooler[0]['id'].substring(0, 7);
    }
    if (widget.buildSchemaStateModel.selectedMotherboard.isNotEmpty) {
      motherboardId = widget.buildSchemaStateModel.selectedMotherboard[0]['id']
          .substring(0, 7);
    }
    if (widget.buildSchemaStateModel.selectedGPU.isNotEmpty) {
      gpuId = widget.buildSchemaStateModel.selectedGPU[0]['id'].substring(0, 7);
    }
    if (widget.buildSchemaStateModel.selectedCPU.isNotEmpty) {
      cpuId = widget.buildSchemaStateModel.selectedCPU[0]['id'].substring(0, 7);
    }
    if (widget.buildSchemaStateModel.selectedPSU.isNotEmpty) {
      psuId = widget.buildSchemaStateModel.selectedPSU[0]['id'].substring(0, 7);
    }
    if (widget.buildSchemaStateModel.selectedRAM.isNotEmpty) {
      ramId = widget.buildSchemaStateModel.selectedRAM[0]['id'].substring(0, 7);
    }
    if (widget.buildSchemaStateModel.currentSelectedRAMCount != 0) {
      ramCount =
          widget.buildSchemaStateModel.currentSelectedRAMCount.toString();
    }
    if (widget.buildSchemaStateModel.selectedStorage.isNotEmpty) {
      storageId =
          widget.buildSchemaStateModel.selectedStorage[0]['id'].substring(0, 7);
    }

    txt.text = caseId +
        "/" +
        coolingId +
        "/" +
        motherboardId +
        "/" +
        gpuId +
        "/" +
        cpuId +
        "/" +
        psuId +
        "/" +
        ramId +
        "/" +
        ramCount +
        "/" +
        storageId;
  }

  @override
  Widget build(BuildContext context) {
    generateExportCode();
    return Scaffold(
        body: SafeArea(
            child: CustomAppBarBack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitledContainer(
                  withBottomRightBorder: true,
                  title: "Export Build",
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            "Use the Build Code below to export your schema",
                            style: TextStyles.sourceSans3,
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: TextField(
                          controller: txt,
                          textAlign: TextAlign.center,
                          readOnly: true,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: ElevatedButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: txt.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  GenericUIFunctions.snackBar(
                                      "Copied to clipboard"));
                            },
                            child: const Text('Copy'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black,
                            )),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ],
    ) // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}

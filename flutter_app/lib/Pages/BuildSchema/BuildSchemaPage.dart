import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_skripsi/Pages/BuildSchema/BuildSchemaStateModel.dart';
import 'package:project_skripsi/Pages/BuildSchema/EstimatedPriceWidget.dart';
import 'package:project_skripsi/UI/FadeBlackBackground.dart';
import 'package:project_skripsi/Variables/GlobalVariables.dart';
import 'package:provider/provider.dart';
import '../../UI/CustomAppbar.dart';

class BuildSchemaPage extends StatefulWidget {
  const BuildSchemaPage({Key? key}) : super(key: key);

  @override
  State<BuildSchemaPage> createState() => _BuildSchemaPageState();
}

class _BuildSchemaPageState extends State<BuildSchemaPage> {
  bool _blackBackground = false;
  void _toggleBlackBackground(){
    setState(() {
      _blackBackground = !_blackBackground;
    });
  }

  void _goToPartInfoPage(BuildSchemaStateModel stateModel, PartEnum partEnum, String id){
    stateModel.changeSelectedPartEnum(partEnum);
    stateModel.changeSelectedPartModelId(id);
    stateModel.changeSidebarState(2);
  }

  final ColorFilter disabledColor = ColorFilter.mode(Colors.grey.shade800, BlendMode.modulate);
  final ColorFilter enabledColor = const ColorFilter.mode(Colors.white, BlendMode.modulate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => BuildSchemaStateModel(),
          child: CustomAppbar(
            isTextFieldEnabled: true,
            sideBarVisible: true,
            children: [
              Container(),
              Positioned(
                  top: MediaQuery.of(context).size.height*0.39,
                  left: MediaQuery.of(context).size.width*0.56,
                  child: Consumer<BuildSchemaStateModel>(
                      builder: (context, value, child) => GestureDetector(
                        onTap: () {
                          if(value.selectedPSU.isNotEmpty){
                            value.changeSidebarToggle();
                            _goToPartInfoPage(value, PartEnum.psu, value.selectedPSU[0]['id']);
                          }
                        }, // Image tapped
                        child: ColorFiltered(
                          colorFilter: value.selectedPSU.isNotEmpty ? enabledColor : disabledColor,
                          child: Image.asset(
                            'assets/img/psu2.png',
                            fit: BoxFit.fill, // Fixes border issues
                            width: MediaQuery.of(context).size.width*0.25,
                            height: MediaQuery.of(context).size.width*0.25*0.5,
                          ),
                        )
                      )
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*0.39,
                  left: MediaQuery.of(context).size.width*0.26,
                  child: Consumer<BuildSchemaStateModel>(
                      builder: (context, value, child) => GestureDetector(
                        onTap: () {
                          if(value.selectedCooler.isNotEmpty){
                            value.changeSidebarToggle();
                            _goToPartInfoPage(value, PartEnum.cooling, value.selectedCooler[0]['id']);
                          }
                        }, // Image tapped
                        child: ColorFiltered(
                          colorFilter: value.selectedCooler.isNotEmpty ? enabledColor : disabledColor,
                          child: Image.asset(
                            'assets/img/cooling2.png',
                            fit: BoxFit.fill, // Fixes border issues
                            width: MediaQuery.of(context).size.width*0.25,
                            height: MediaQuery.of(context).size.width*0.25*0.5,
                          ),
                        )
                      )
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*0.5,
                  left: MediaQuery.of(context).size.width*0.1,
                  child: Consumer<BuildSchemaStateModel>(
                      builder: (context, value, child) => GestureDetector(
                          onTap: () {
                            if(value.selectedMotherboard.isNotEmpty){
                              value.changeSidebarToggle();
                              _goToPartInfoPage(value, PartEnum.motherboard, value.selectedMotherboard[0]['id']);
                            }
                          }, // Image tapped
                          child: ColorFiltered(
                            colorFilter: value.selectedMotherboard.isNotEmpty ? enabledColor : disabledColor,
                            child: Image.asset(
                              'assets/img/motherboard2.png',
                              fit: BoxFit.fill, // Fixes border issues
                              width: MediaQuery.of(context).size.width*0.9,
                              height: MediaQuery.of(context).size.width*0.9*0.2,
                            ),
                          )
                      )
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*0.54,
                  left: MediaQuery.of(context).size.width*0.23,
                  child: Consumer<BuildSchemaStateModel>(
                      builder: (context, value, child) => GestureDetector(
                        onTap: () {
                          if(value.selectedGPU.isNotEmpty){
                            value.changeSidebarToggle();
                            _goToPartInfoPage(value, PartEnum.gpu, value.selectedGPU[0]['id']);
                          }
                        }, // Image tapped
                        child: ColorFiltered(
                          colorFilter: value.selectedGPU.isNotEmpty ? enabledColor : disabledColor,
                          child: Image.asset(
                            'assets/img/gpu2.png',
                            fit: BoxFit.fill, // Fixes border issues
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.width*0.4*0.3,
                          ),
                        )
                      )
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*0.46,
                  left: MediaQuery.of(context).size.width*0.75,
                  child: Consumer<BuildSchemaStateModel>(
                      builder: (context, value, child) => GestureDetector(
                        onTap: () {
                          if(value.selectedRAM.isNotEmpty){
                            value.changeSidebarToggle();
                            _goToPartInfoPage(value, PartEnum.ram, value.selectedRAM[0]['id']);
                          }
                        }, // Image tapped
                        child: ColorFiltered(
                          colorFilter: value.selectedRAM.isNotEmpty ? enabledColor : disabledColor,
                          child: Image.asset(
                            'assets/img/ram.png',
                            fit: BoxFit.fill, // Fixes border issues
                            width: MediaQuery.of(context).size.width*0.17*0.84,
                            height: MediaQuery.of(context).size.width*0.17,
                          ),
                        )
                      )
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*0.57,
                  left: MediaQuery.of(context).size.width*0.63,
                  child: Consumer<BuildSchemaStateModel>(
                      builder: (context, value, child) => GestureDetector(
                        onTap: () {
                          if(value.selectedStorage.isNotEmpty){
                            value.changeSidebarToggle();
                            _goToPartInfoPage(value, PartEnum.storage, value.selectedStorage[0]['id']);
                          }
                        }, // Image tapped
                        child: ColorFiltered(
                          colorFilter: value.selectedStorage.isNotEmpty ? enabledColor : disabledColor,
                          child: Image.asset(
                            'assets/img/storage2.png',
                            fit: BoxFit.fill, // Fixes border issues
                            width: MediaQuery.of(context).size.width*0.35,
                            height: MediaQuery.of(context).size.width*0.35*0.2,
                          ),
                        )
                      )
                  )
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*0.52,
                  left: MediaQuery.of(context).size.width*0.56,
                  child: Consumer<BuildSchemaStateModel>(
                      builder: (context, value, child) => GestureDetector(
                        onTap: () {
                          if(value.selectedCPU.isNotEmpty){
                            value.changeSidebarToggle();
                            _goToPartInfoPage(value, PartEnum.cpu, value.selectedCPU[0]['id']);
                          }
                        }, // Image tapped
                        child: ColorFiltered(
                          colorFilter: value.selectedCPU.isNotEmpty ? enabledColor : disabledColor,
                          child: Image.asset(
                            'assets/img/processor2.png',
                            fit: BoxFit.fill, // Fixes border issues
                            width: MediaQuery.of(context).size.width*0.25,
                            height: MediaQuery.of(context).size.width*0.25*0.2,
                          ),
                        )
                      )
                  )
              ),
              FadeBlackBackground(toggleVariable: _blackBackground),
              EstimatedPriceWidget(blackBackgroundCallback: () => _toggleBlackBackground())
            ],
          ),
        )
      )
    );
  }
}

// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_skripsi/UI/CorneredButton.dart';
import 'package:project_skripsi/UI/CustomContainer.dart';
import 'package:project_skripsi/UI/GradientRectSliderTrackShape.dart';
import 'package:project_skripsi/UI/Palette.dart';
import 'package:project_skripsi/UI/RecommendPageSlider.dart';

import '../UI/CustomAppbar.dart';

class RecommendedFormPage extends StatefulWidget {
  const RecommendedFormPage({Key? key}) : super(key: key);

  @override
  State<RecommendedFormPage> createState() => _RecommendedFormPageState();
}

class _RecommendedFormPageState extends State<RecommendedFormPage> {
  String tempValue = "";
  TextEditingController userInput = TextEditingController();
  int CaseSlider = 50;
  int MBSlider = 50;
  int CPUSlider = 50;
  int PSUSlider = 50;
  int RAMSlider = 50;
  int CoolingSlider = 50;
  int GPUSlider = 50;
  int StorageSlider = 50;

  callbackCase(newValue) {
    setState(() {
      CaseSlider = newValue;
    });
  }

  callbackMB(newValue) {
    setState(() {
      MBSlider = newValue;
    });
  }

  callbackCPU(newValue) {
    setState(() {
      CPUSlider = newValue;
    });
  }

  callbackPSU(newValue) {
    setState(() {
      PSUSlider = newValue;
    });
  }

  callbackRAM(newValue) {
    setState(() {
      RAMSlider = newValue;
    });
  }

  callbackCooling(newValue) {
    setState(() {
      CoolingSlider = newValue;
    });
  }

  callbackGPU(newValue) {
    setState(() {
      GPUSlider = newValue;
    });
  }

  callbackStorage(newValue) {
    setState(() {
      StorageSlider = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomContainer(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.9,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Container(
                        margin:
                            const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Intended Use: ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  softWrap: true,
                                ),
                                Container(
                                  width: 150,
                                  height: 25,
                                  margin: const EdgeInsets.only(left: 25),
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: tempValue,
                                          items: dropdownItems,
                                          dropdownColor: Colors.white,
                                          onChanged: (String? value) {
                                            setState(() {
                                              tempValue = value!;
                                            });
                                          }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Budget: ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  softWrap: true,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 65),
                                  width: 150,
                                  height: 25,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: TextFormField(
                                    maxLength: 14,
                                    controller: userInput,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "",
                                      counterText: '',
                                      contentPadding: EdgeInsets.only(
                                          left: 10,
                                          bottom: 0,
                                          top: 18,
                                          right: 10),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RecommendPageSlider(
                                callback: callbackCase,
                                sliderName: "Case: ",
                                sliderValue: CaseSlider),
                            RecommendPageSlider(
                                callback: callbackMB,
                                sliderName: "Motherboard: ",
                                sliderValue: MBSlider),
                            RecommendPageSlider(
                                callback: callbackCPU,
                                sliderName: "CPU: ",
                                sliderValue: CPUSlider),
                            RecommendPageSlider(
                                callback: callbackRAM,
                                sliderName: "RAM: ",
                                sliderValue: RAMSlider),
                            RecommendPageSlider(
                                callback: callbackCooling,
                                sliderName: "Cooling: ",
                                sliderValue: CoolingSlider),
                            RecommendPageSlider(
                                callback: callbackGPU,
                                sliderName: "GPU: ",
                                sliderValue: GPUSlider),
                            RecommendPageSlider(
                                callback: callbackPSU,
                                sliderName: "PSU: ",
                                sliderValue: PSUSlider),
                            RecommendPageSlider(
                                callback: callbackStorage,
                                sliderName: "Storage: ",
                                sliderValue: StorageSlider),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CorneredButton(
                                    onPressed: () {},
                                    child: Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Text(
                                        "Continue",
                                        style: TextStyles.interStyle1,
                                      ),
                                    ),
                                  )
                                ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
        ],
      ),
    );
  }
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(child: const Text("Select One"), value: ""),
    const DropdownMenuItem(child: const Text("Bury"), value: "Cast Aside"),
    const DropdownMenuItem(child: const Text("The"), value: "There is"),
    const DropdownMenuItem(child: const Text("Light"), value: "No"),
    const DropdownMenuItem(child: const Text("Deep"), value: "Coming"),
    const DropdownMenuItem(child: const Text("Within"), value: "Home"),
  ];
  return menuItems;
}

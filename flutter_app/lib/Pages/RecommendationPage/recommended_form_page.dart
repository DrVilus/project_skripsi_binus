// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_skripsi/Pages/RecommendationPage/recommended_loading_page.dart';
import 'package:project_skripsi/UI/cornered_button.dart';
import 'package:project_skripsi/UI/custom_app_bar_back.dart';
import 'package:project_skripsi/UI/custom_container.dart';
import 'package:project_skripsi/UI/palette.dart';

import '../../Functions/generic_ui_functions.dart';

class RecommendedFormPage extends StatefulWidget {
  const RecommendedFormPage({Key? key}) : super(key: key);

  @override
  State<RecommendedFormPage> createState() => _RecommendedFormPageState();
}

class _RecommendedFormPageState extends State<RecommendedFormPage> {
  String tempValue = "1";
  String chipsetValue = "Intel";
  TextEditingController userInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAppBarBack(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomContainer(
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
                                  "Chipset: ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  softWrap: true,
                                ),
                                Container(
                                  width: 150,
                                  height: 25,
                                  margin: const EdgeInsets.only(left: 60),
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: chipsetValue,
                                          items: dropdownChipsetItems,
                                          dropdownColor: Colors.white,
                                          onChanged: (String? value) {
                                            setState(() {
                                              chipsetValue = value!;
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
                              children: [
                                const Text(
                                  "Minimum Budget is Rp 5.000.000",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  softWrap: true,
                                ),
                              ],
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
                                      hintText: "",
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
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CorneredButton(
                                  onPressed: () {
                                    if (userInput.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              GenericUIFunctions.snackBar(
                                                  "Budget field is empty"));
                                      return;
                                    }
                                    if (int.parse(userInput.text) < 5000000) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          GenericUIFunctions.snackBar(
                                              "Minimum budget value is 5,000,000"));
                                      return;
                                    }
                                    if (userInput.text.isNotEmpty) {
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              RecommendedLoadingPage(
                                            budget:
                                                double.parse(userInput.text),
                                            targetMarketCode: tempValue,
                                            chipset: chipsetValue,
                                          ),
                                          transitionDuration: Duration.zero,
                                        ),
                                      );
                                    }
                                  },
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
    const DropdownMenuItem(child: Text("Office"), value: "1"),
    const DropdownMenuItem(child: Text("Gaming"), value: "2"),
    const DropdownMenuItem(child: Text("Workstation"), value: "3"),
  ];
  return menuItems;
}

List<DropdownMenuItem<String>> get dropdownChipsetItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(child: Text("Intel"), value: "Intel"),
    const DropdownMenuItem(child: Text("AMD"), value: "AMD"),
  ];
  return menuItems;
}

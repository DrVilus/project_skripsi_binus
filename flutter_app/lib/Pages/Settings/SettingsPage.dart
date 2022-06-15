import 'package:flutter/material.dart';
import 'package:project_skripsi/UI/CorneredButton.dart';
import 'package:project_skripsi/UI/CustomAppBarBack.dart';
import 'package:project_skripsi/UI/Palette.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomAppBarBack(
          title: "Settings",
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20.0, 160.0, 20.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          children: [
                            Expanded(
                              child: CorneredButton(
                                onPressed: () {},
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                                    child: Text(
                                      "Settings #1",
                                      style: TextStyles.interStyleBuildGuidePageButton,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          children: [
                            Expanded(
                              child: CorneredButton(
                                onPressed: () {},
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                                    child: Text(
                                      "Settings #2",
                                      style: TextStyles.interStyleBuildGuidePageButton,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          children: [
                            Expanded(
                              child: CorneredButton(
                                onPressed: () {},
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                                    child: Text(
                                      "Settings #3",
                                      style: TextStyles.interStyleBuildGuidePageButton,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),  
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          children: [
                            Expanded(
                              child: CorneredButton(
                                onPressed: () {},
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                                    child: Text(
                                      "Settings #4",
                                      style: TextStyles.interStyleBuildGuidePageButton,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
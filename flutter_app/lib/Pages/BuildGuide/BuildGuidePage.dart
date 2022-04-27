import 'package:flutter/material.dart';
import 'package:project_skripsi/UI/CorneredButton.dart';
import 'package:project_skripsi/UI/CustomAppBarBack.dart';
import 'package:project_skripsi/UI/Palette.dart';

class BuildGuidePage extends StatefulWidget {
  const BuildGuidePage({ Key? key }) : super(key: key);

  @override
  State<BuildGuidePage> createState() => _BuildGuidePageState();
}

class _BuildGuidePageState extends State<BuildGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomAppBarBack(
          title: "BUILD GUIDE",
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
                      Container(
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
                                      "GUIDE #1",
                                      style: TextStyles.interStyleBuildGuidePage,
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
                      Container(
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
                                      "GUIDE #2",
                                      style: TextStyles.interStyleBuildGuidePage,
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
                      Container(
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
                                      "GUIDE #3",
                                      style: TextStyles.interStyleBuildGuidePage,
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
                      Container(
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
                                      "GUIDE #4",
                                      style: TextStyles.interStyleBuildGuidePage,
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
                      Container(
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
                                      "GUIDE #5",
                                      style: TextStyles.interStyleBuildGuidePage,
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
                      Container(
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
                                      "GUIDE #6",
                                      style: TextStyles.interStyleBuildGuidePage,
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
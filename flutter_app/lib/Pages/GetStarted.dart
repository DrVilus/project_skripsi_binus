import 'package:flutter/material.dart';
import 'package:project_skripsi/Pages/BuildSchema/BuildSchemaPage.dart';
import 'package:project_skripsi/Pages/BuildSchema/BuildSchemaStateModel.dart';
import 'package:project_skripsi/Pages/RecommendedFormPage.dart';
import 'package:project_skripsi/UI/CorneredButton.dart';
import 'package:project_skripsi/UI/Palette.dart';
import 'package:project_skripsi/UI/TitledContainer.dart';
import '../UI/CustomAppbar.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          body: SafeArea(
            child: CustomAppbar (
              sideBarVisible: false,
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
                          title: "Get Started",
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: CorneredButton(
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1, animation2) => const BuildSchemaPage(),
                                              transitionDuration: Duration.zero,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                                          child: Text("Start a new build", style: TextStyles.interStyle1,),
                                        ),
                                      )
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CorneredButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder:
                                              (context, animation1, animation2) =>
                                                const RecommendedFormPage(),
                                                  transitionDuration: Duration.zero,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding:
                                          const EdgeInsets.only(top: 15, bottom: 15),
                                          child: Text(
                                            "Get recommended build",
                                            style: TextStyles.interStyle1,
                                          ),
                                      ),
                                    )
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: CorneredButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                                          child: Text("Import Build", style: TextStyles.interStyle1,),
                                        ),
                                      )
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),

              ],
            )
          ) // This trailing comma makes auto-formatting nicer for build methods.
      );


  }
}


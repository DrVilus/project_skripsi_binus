import 'package:flutter/material.dart';
import 'package:project_skripsi/Pages/BuildSchema/build_schema_page.dart';
import 'package:project_skripsi/Pages/BuildSchema/build_schema_state_model.dart';
import 'package:project_skripsi/Pages/RecommendationPage/recommended_form_page.dart';
import 'package:project_skripsi/UI/cornered_button.dart';
import 'package:project_skripsi/UI/palette.dart';
import 'package:project_skripsi/UI/titled_container.dart';
import 'package:provider/provider.dart';
import '../UI/custom_app_bar.dart';
import 'ImportExport/import_page.dart';

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
            child: ChangeNotifierProvider(
              create: (context) => BuildSchemaStateModel(),
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
                                          onPressed: (){
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder:
                                                    (context, animation1, animation2) =>
                                                const ImportPage(),
                                                transitionDuration: Duration.zero,
                                              ),
                                            );
                                          },
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
              ),
            )
          ) // This trailing comma makes auto-formatting nicer for build methods.
      );
  }
}


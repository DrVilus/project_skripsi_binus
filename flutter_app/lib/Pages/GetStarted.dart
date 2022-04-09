import 'package:flutter/material.dart';
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
          body: Stack(
            children: [
              TitledContainer(
                withBottomRightBorder: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: CorneredButton(
                              child: Text("Shit"),
                            )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: CorneredButton(
                              child: Text("Shit"),
                            )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: CorneredButton(
                              child: Text("Shit"),
                            )
                        )
                      ],
                    )
                  ],
                ),
              ),
              SafeArea(
                child: CustomAppbar(
                  title: "Test",
                  sideBarOpacity: 0,
                ),
              ),
            ],
          ) // This trailing comma makes auto-formatting nicer for build methods.
      );


  }
}

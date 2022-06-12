import 'package:flutter/material.dart';
import 'package:project_skripsi/Pages/ImportExport/ImportPageLoading.dart';
import 'package:project_skripsi/UI/CustomAppBarBack.dart';
import 'package:project_skripsi/UI/TitledContainer.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({Key? key}) : super(key: key);

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  TextEditingController userInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  title: "Import Build",
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: TextField(
                          controller: userInput,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            hintText: 'Enter Code',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) =>
                                      ImportLoadingPage(
                                        importBuildCode: userInput.text
                                      ),
                                  transitionDuration: Duration.zero,
                                ),
                              );
                            },
                            child: const Text('Submit'),
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

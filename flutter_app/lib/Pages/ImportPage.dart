import 'package:flutter/material.dart';
import 'package:project_skripsi/Pages/BuildSchema/BuildSchemaPage.dart';
import 'package:project_skripsi/Pages/RecommendedFormPage.dart';
import 'package:project_skripsi/UI/CorneredButton.dart';
import 'package:project_skripsi/UI/Palette.dart';
import 'package:project_skripsi/UI/TitledContainer.dart';
import '../UI/CustomAppbar.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({Key? key}) : super(key: key);

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          body: SafeArea(
            child: CustomAppbar (
              title: "",
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
                        title: "Import Build",
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[  
                            Padding(  
                             padding: const EdgeInsets.all(0),
                              child: TextField(  
                                decoration: InputDecoration(  
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),  
                                  hintText: 'Enter Code',  
                                ),  
                              ),  
                            ),    Padding(  
                             padding: const EdgeInsets.all(0),
                       child: ElevatedButton(
                         
              onPressed: () {
              },
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                 primary: Colors.white,
                 onPrimary: Colors.black,
       )
              ),
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
          )
      );


  }
}


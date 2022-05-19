import 'package:flutter/material.dart';
import 'package:project_skripsi/Pages/BuildSchema/BuildSchemaPage.dart';
import 'package:project_skripsi/Pages/RecommendedFormPage.dart';
import 'package:project_skripsi/UI/CorneredButton.dart';
import 'package:project_skripsi/UI/Palette.dart';
import 'package:project_skripsi/UI/TitledContainer.dart';
import '../UI/CustomAppbar.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
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
                                textAlign: TextAlign.center,
                                readOnly: true,
                                decoration: InputDecoration(  
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),  
                                ),  
                              ),  
                            ),    Padding(  
                             padding: const EdgeInsets.all(0),
                       child: ElevatedButton(
                         
              onPressed: () {
              },
              child: const Text('Copy'),
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
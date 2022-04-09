import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_skripsi/GetStarted.dart';
import 'dart:ui' as ui;

import 'package:project_skripsi/Palette.dart';
import 'package:project_skripsi/UI/CustomAppbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Palette.mainBackground
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                          child: Container(
                            child: GetStartedPage(),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              color: Palette.widgetBackground1,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(40),
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                          )
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.3,
                        child: Container(
                          child: Text("Fuck",style: GoogleFonts.getFont('Inter'),),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.1,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            color: Palette.widgetBackground1,
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      )

                    ],
                  )

                ],
              )
            ],
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






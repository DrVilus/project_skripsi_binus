import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_skripsi/Pages/BuildSchema/EstimatedPriceWidget.dart';
import 'package:project_skripsi/UI/FadeBlackBackground.dart';
import '../../UI/CustomAppbar.dart';

class BuildSchemaPage extends StatefulWidget {
  const BuildSchemaPage({Key? key}) : super(key: key);

  @override
  State<BuildSchemaPage> createState() => _BuildSchemaPageState();
}

class _BuildSchemaPageState extends State<BuildSchemaPage> {
  bool _blackBackground = false;
  void _toggleBlackBackground(){
    setState(() {
      _blackBackground = !_blackBackground;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomAppbar(
          isTextFieldEnabled: true,
          sideBarVisible: true,
          children: [
            Container(),
            Positioned(
                top: MediaQuery.of(context).size.height*0.5,
                left: MediaQuery.of(context).size.width*0.1,
                child: GestureDetector(
                  onTap: () {print('mb');}, // Image tapped
                  child: Image.asset(
                    'assets/img/motherboard2.png',
                    fit: BoxFit.fill, // Fixes border issues
                    width: MediaQuery.of(context).size.width*0.9,
                    height: MediaQuery.of(context).size.width*0.9*0.2,
                  ),
                )
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*0.54,
                left: MediaQuery.of(context).size.width*0.23,
                child: GestureDetector(
                  onTap: () {print('gpu');}, // Image tapped
                  child: Image.asset(
                    'assets/img/gpu2.png',
                    fit: BoxFit.fill, // Fixes border issues
                    width: MediaQuery.of(context).size.width*0.4,
                    height: MediaQuery.of(context).size.width*0.4*0.3,
                  ),
                )
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*0.46,
                left: MediaQuery.of(context).size.width*0.75,
                child: GestureDetector(
                  onTap: () {print('ram');}, // Image tapped
                  child: Image.asset(
                    'assets/img/ram.png',
                    fit: BoxFit.fill, // Fixes border issues
                    width: MediaQuery.of(context).size.width*0.17*0.84,
                    height: MediaQuery.of(context).size.width*0.17,
                  ),
                )
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*0.57,
                left: MediaQuery.of(context).size.width*0.63,
                child: GestureDetector(
                  onTap: () {print('ssd');}, // Image tapped
                  child: Image.asset(
                    'assets/img/storage2.png',
                    fit: BoxFit.fill, // Fixes border issues
                    width: MediaQuery.of(context).size.width*0.35,
                    height: MediaQuery.of(context).size.width*0.35*0.2,
                  ),
                )
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*0.52,
                left: MediaQuery.of(context).size.width*0.56,
                child: GestureDetector(
                  onTap: () {print('cpu');}, // Image tapped
                  child: Image.asset(
                    'assets/img/processor2.png',
                    fit: BoxFit.fill, // Fixes border issues
                    width: MediaQuery.of(context).size.width*0.25,
                    height: MediaQuery.of(context).size.width*0.25*0.2,
                  ),
                )
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*0.3,
                left: MediaQuery.of(context).size.width*0.56,
                child: GestureDetector(
                  onTap: () {print('psu');}, // Image tapped
                  child: Image.asset(
                    'assets/img/psu2.png',
                    fit: BoxFit.fill, // Fixes border issues
                    width: MediaQuery.of(context).size.width*0.25,
                    height: MediaQuery.of(context).size.width*0.25*0.5,
                  ),
                )
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*0.3,
                left: MediaQuery.of(context).size.width*0.26,
                child: GestureDetector(
                  onTap: () {print('cooling');}, // Image tapped
                  child: Image.asset(
                    'assets/img/cooling2.png',
                    fit: BoxFit.fill, // Fixes border issues
                    width: MediaQuery.of(context).size.width*0.25,
                    height: MediaQuery.of(context).size.width*0.25*0.5,
                  ),
                )
            ),

            FadeBlackBackground(toggleVariable: _blackBackground),
            EstimatedPriceWidget(blackBackgroundCallback: () => _toggleBlackBackground())
          ],
        ),
      )
    );
  }
}

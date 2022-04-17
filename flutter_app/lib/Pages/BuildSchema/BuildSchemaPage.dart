import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../UI/CustomAppbar.dart';

class BuildSchemaPage extends StatefulWidget {
  const BuildSchemaPage({Key? key}) : super(key: key);

  @override
  State<BuildSchemaPage> createState() => _BuildSchemaPageState();
}

class _BuildSchemaPageState extends State<BuildSchemaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomAppbar(
          title: "PC Build #1",
          sideBarVisible: true,
          children: [
            Container(),
          ],
        ),
      )
    );
  }
}

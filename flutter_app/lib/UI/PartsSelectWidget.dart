import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_skripsi/Pages/BuildSchema/BuildSchemaStateModel.dart';
import 'package:project_skripsi/UI/Palette.dart';

class PartsSelectWidget extends StatelessWidget {
  const PartsSelectWidget({Key? key, required this.imgPath, required this.name, required this.function, required this.selectedPart}) : super(key: key);
  final String imgPath;
  final String name;
  final Function function;
  final String selectedPart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(color: Palette.grey, width: 25, height: 25),
                      Text(name, style: TextStyles.sourceSans3,)
                    ],
                  )
              ),
              Expanded(
                flex: 5,
                child: Stack(
                  children: <Widget>[
                    Center(
                        child: Image.asset(imgPath)
                    ),
                  ],
                ),
              ),
              if(selectedPart != "")Expanded(
                flex: 2,
                child: Stack(
                  children: <Widget>[
                    Center(
                        child: Text(selectedPart, style: TextStyles.sourceSans3,)
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}

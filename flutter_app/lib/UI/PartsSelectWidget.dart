import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_skripsi/UI/Palette.dart';

class PartsSelectWidget extends StatelessWidget {
  const PartsSelectWidget({Key? key, required this.imgPath, required this.name, required this.function}) : super(key: key);
  final String imgPath;
  final String name;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: Container(
          padding: EdgeInsets.all(10),
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
              )

            ],
          )
      ),
    );
  }
}

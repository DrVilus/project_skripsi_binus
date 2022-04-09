import 'package:flutter/material.dart';
import 'Palette.dart';

class TitledContainer extends StatelessWidget {
  const TitledContainer({Key? key, this.child, this.withBottomRightBorder = false}) : super(key: key);
  final Widget? child;
  final bool withBottomRightBorder;

  @override
  Widget build(BuildContext context) {
    Radius bottomRightRadius;
    if(withBottomRightBorder == true){
      bottomRightRadius = const Radius.circular(40);
    }else{
      bottomRightRadius = const Radius.circular(10);
    }
    return
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
                        child: child,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          color: Palette.widgetBackground1,
                          borderRadius: BorderRadius.only(
                            bottomRight: bottomRightRadius,
                            topRight: const Radius.circular(10),
                            topLeft: const Radius.circular(10),
                            bottomLeft: const Radius.circular(10),
                          ),
                        ),
                      )
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.3,
                    child: Container(
                      child: Text("Fuck",style: TextStyles.interStyle1),
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
      );
  }
}

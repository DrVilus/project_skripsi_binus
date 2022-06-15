import 'package:flutter/material.dart';
import 'package:project_skripsi/UI/custom_app_bar.dart';
import 'package:project_skripsi/UI/palette.dart';

class CustomAppBarBack extends StatefulWidget {
  const CustomAppBarBack({Key? key, this.title, required this.children})
      : super(key: key);

  final String? title;
  final List<Widget> children;

  @override
  State<CustomAppBarBack> createState() => _CustomAppBarBackState();
}

class _CustomAppBarBackState extends State<CustomAppBarBack> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: CustomPaint(
            size: Size(
                MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.width * 0.1806853582554517)
                    .toDouble()),
            //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
            painter: CustomPainterAppbar(),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Padding(
                    padding: const EdgeInsets.only(left: 150, right: 30),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                            child: Center(
                          child: Text(
                            widget.title ?? "",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            softWrap: true,
                          ),
                        )),
                      ],
                    ))),
          ),
        ),
        ...widget.children,
        Positioned(
          top: -25,
          left: -30,
          child: ElevatedButton(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 60,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 150),
                shape: const CircleBorder(),
                primary: Palette.widgetBackground1,
                side: const BorderSide(width: 2, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

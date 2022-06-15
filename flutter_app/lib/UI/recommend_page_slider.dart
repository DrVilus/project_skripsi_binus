// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:project_skripsi/UI/gradient_rect_slider_track_shape.dart';

class RecommendPageSlider extends StatefulWidget {
  final Function(int) callback;
  final String? sliderName;
  final int sliderValue;

  const RecommendPageSlider(
      {Key? key,
      required this.callback,
      this.sliderName,
      required this.sliderValue})
      : super(key: key);

  @override
  State<RecommendPageSlider> createState() => _RecommendPageSliderState();
}

class _RecommendPageSliderState extends State<RecommendPageSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.sliderName ?? "",
                style: const TextStyle(color: Colors.white, fontSize: 13),
                softWrap: true,
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 25.0, 0.0),
                child: Text(
                  "Est. Price",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                  softWrap: true,
                ),
              ),
            ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                          trackShape: const GradientRectSliderTrackShape()),
                      child: Slider(
                        value: widget.sliderValue.toDouble(),
                        max: 100,
                        onChanged: (double value) {
                          setState(() {
                            widget.callback(value.round());
                          });
                        },
                      ))),
            ]),
      ],
    );
  }
}

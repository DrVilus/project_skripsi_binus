import 'package:flutter/material.dart';
import 'package:project_skripsi/UI/custom_app_bar_back.dart';
import 'package:project_skripsi/UI/palette.dart';

import '../../Models/build_guide_model.dart';

class BuildGuideDescriptionPage extends StatelessWidget {
  const BuildGuideDescriptionPage({Key? key,required this.buildGuideModel}) : super(key: key);
  final BuildGuideModel buildGuideModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomAppBarBack(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.2,
                  left: 30, right: 30, bottom: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(child: Text(buildGuideModel.guideTitle, style: TextStyles.interStyleBuildGuidePageTitle,))
                      ],
                    ),

                    if(buildGuideModel.guideImageLink.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.asset(buildGuideModel.guideImageLink)
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(child: Text(buildGuideModel.guideDescription, style: TextStyles.interStyleBuildGuidePageDescription,), )
                      ],
                    )
                  ],
                )
              )
            )
          ],
        ),
      ),
    );
  }
}

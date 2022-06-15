import 'package:flutter/material.dart';
import 'package:project_skripsi/Models/build_guide_model.dart';
import 'package:project_skripsi/Pages/BuildGuide/build_guide_description_page.dart';
import 'package:project_skripsi/UI/cornered_button.dart';
import 'package:project_skripsi/UI/custom_app_bar_back.dart';
import 'package:project_skripsi/UI/palette.dart';

class BuildGuideListPage extends StatefulWidget {
  const BuildGuideListPage(
      {Key? key, required this.buildGuideModelListWithTitle})
      : super(key: key);
  final BuildGuideModelListWithTitle buildGuideModelListWithTitle;

  @override
  State<BuildGuideListPage> createState() => _BuildGuideListPageState();
}

class _BuildGuideListPageState extends State<BuildGuideListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomAppBarBack(
        title: widget.buildGuideModelListWithTitle.guideTitle,
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(20.0, 160.0, 20.0, 10.0),
              child: Scrollbar(
                child: CustomScrollView(slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 30, right: 20),
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          children: [
                            Expanded(
                              child: CorneredButton(
                                onPressed: () {
                                  if (widget.buildGuideModelListWithTitle
                                          .guideList[index]
                                      is BuildGuideModelListWithTitle) {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                BuildGuideListPage(
                                          buildGuideModelListWithTitle: widget
                                              .buildGuideModelListWithTitle
                                              .guideList[index],
                                        ),
                                        transitionDuration: Duration.zero,
                                      ),
                                    );
                                  } else if (widget.buildGuideModelListWithTitle
                                      .guideList[index] is BuildGuideModel) {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation1,
                                                animation2) =>
                                            BuildGuideDescriptionPage(
                                                buildGuideModel: widget
                                                    .buildGuideModelListWithTitle
                                                    .guideList[index]),
                                        transitionDuration: Duration.zero,
                                      ),
                                    );
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Text(
                                      widget.buildGuideModelListWithTitle
                                          .guideList[index].guideTitle,
                                      style: TextStyles
                                          .interStyleBuildGuidePageButton,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount:
                        widget.buildGuideModelListWithTitle.guideList.length,
                  ))
                ]),
              )),
        ],
      ),
    ));
  }
}

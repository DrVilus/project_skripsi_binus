import 'package:flutter/cupertino.dart';

import '../../Models/RecommendationModels.dart';

class RecommendedResultPage extends StatefulWidget {
  const RecommendedResultPage({Key? key, required this.fullPcPartModelList}) : super(key: key);
  final List<FullPcPartModel> fullPcPartModelList;

  @override
  State<RecommendedResultPage> createState() => _RecommendedResultPageState();
}

class _RecommendedResultPageState extends State<RecommendedResultPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

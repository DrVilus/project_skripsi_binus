class BuildGuideModel{
  String guideTitle = "";
  String guideDescription = "";
  String guideImageLink = "";

  BuildGuideModel(String guideTitleInput, String guideDescriptionInput, String guideImageLinkInput){
    guideTitle = guideTitleInput;
    guideDescription = guideDescriptionInput;
    guideImageLink = guideImageLinkInput;
  }
}

class BuildGuideModelListWithTitle{
  String guideTitle = "";
  late List<dynamic> guideList;

  BuildGuideModelListWithTitle(String guideTitleInput, List<dynamic> guideListInput){
    guideTitle = guideTitleInput;
    guideList = guideListInput;
  }
}
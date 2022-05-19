class PartsSelectModel {
  String name = '';
  String assetPath = '';
  int index = 0;
  String query = """""";
  String queryById = """""";

  PartsSelectModel(String nameInput, String assetPathInput, int indexInput, String queryInput, String queryByIdInput){
    name = nameInput;
    assetPath = assetPathInput;
    index = indexInput;
    query = queryInput;
    queryById = queryByIdInput;
  }
}
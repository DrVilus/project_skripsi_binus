import 'package:project_skripsi/Variables/global_variables.dart';

class PartsSelectModel {
  String name = '';
  String assetPath = '';
  PartEnum partEnumVariable = PartEnum.others;
  String query = """""";
  String queryById = """""";

  PartsSelectModel(String nameInput, String assetPathInput, PartEnum partEnumInput, String queryInput, String queryByIdInput){
    name = nameInput;
    assetPath = assetPathInput;
    partEnumVariable = partEnumInput;
    query = queryInput;
    queryById = queryByIdInput;
  }
}
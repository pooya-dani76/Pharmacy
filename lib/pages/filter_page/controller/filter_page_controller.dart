import 'package:get/get.dart';
import 'package:pharmacy/pages/widgets/lazy_load/lazy_load.dart';

class FilterPageController extends GetxController {

  loadData({required Map getArguments}){
    arguments = Map.from(getArguments);
    String sql  = "";
    if (arguments!.keys.toList().contains("category")) {
    sql = """Select  Drugs.* from DrugCategories
    INNER JOIN DrugToCategories on DrugCategories.id=DrugToCategories.category
    INNER join Drugs on Drugs.id=DrugToCategories.drug 
    WHERE DrugCategories.id=${arguments!['category']['id']}""";
    } else {
      sql = """Select  Drugs.* from DrugShapes
    INNER JOIN DrugToShapes on DrugShapes.id=DrugToShapes.shape
    INNER join Drugs on Drugs.id=DrugToShapes.drug WHERE DrugShapes.id=${arguments!['shape']['id']}""";
    }
    loader = LazyLoad(sqlCommands: [
      sql,
      """Select Drugs.id, DrugCategories.name as category from Drugs
    INNER JOIN DrugToCategories on Drugs.id=DrugToCategories.drug
    INNER JOIN DrugCategories on DrugToCategories.category=DrugCategories.id"""
    ]);
    loader!.afterLoad = () => update();
  }

  LazyLoad? loader;
  Map? arguments;
}

Map titleNames = {
  "shape": "شکل دارویی",
  "category": "دسته بندی",
};

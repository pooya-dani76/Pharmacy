// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'package:pharmacy/pages/widgets/lazy_load/lazy_load.dart';

class DrugPageController extends GetxController {
  @override
  void onInit() {
    loader = LazyLoad(sqlCommands: [
      """SELECT Drugs.*,
    group_concat(DrugCategories.name,'#') AS categories
    FROM Drugs 
    LEFT JOIN DrugToCategories ON Drugs.id = DrugToCategories.drug 
    LEFT JOIN DrugCategories ON DrugCategories.id = DrugToCategories.category 
    GROUP BY Drugs.id 
    ORDER BY Drugs.name""",
    ]);
    loader!.afterLoad = () => update();
    super.onInit();
  }

  LazyLoad? loader;
}

searchDrugs({required String value}) async {
  DrugPageController drugPageController = Get.find<DrugPageController>();
  drugPageController.loader = LazyLoad(
    sqlCommands: [
      """SELECT Drugs.*,
    group_concat(DrugCategories.name,'#') AS categories
    FROM Drugs 
    LEFT JOIN DrugToCategories ON Drugs.id = DrugToCategories.drug 
    LEFT JOIN DrugCategories ON DrugCategories.id = DrugToCategories.category 
    Where Drugs.name Like "%$value%"
    GROUP BY Drugs.id 
    ORDER BY Drugs.name""",
    ],
    afterLoad: () => drugPageController.update(),
  );
}

cancelSearchDrug() {
  DrugPageController drugPageController = Get.find<DrugPageController>();
  drugPageController.loader = LazyLoad(
    sqlCommands: [
      """SELECT Drugs.*,
    group_concat(DrugCategories.name,'#') AS categories
    FROM Drugs 
    JOIN DrugToCategories ON Drugs.id = DrugToCategories.drug 
    JOIN DrugCategories ON DrugCategories.id = DrugToCategories.category 
    GROUP BY Drugs.id 
    ORDER BY Drugs.name""",
    ],
    afterLoad: () => drugPageController.update(),
  );
}

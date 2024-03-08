import 'package:get/get.dart';
import 'package:pharmacy/pages/backup_page/controller/backup_controller.dart';
import 'package:pharmacy/pages/category_edit_page/controller/category_edit_controller.dart';
import 'package:pharmacy/pages/category_edit_page/view/category_edit_page.dart';
import 'package:pharmacy/pages/category_page/controller/category_page_controller.dart';
import 'package:pharmacy/pages/drug_edit_page/controller/drug_edit_page_controller.dart';
import 'package:pharmacy/pages/drug_edit_page/view/drug_edit_page.dart';
import 'package:pharmacy/pages/drug_page/controller/drug_page_controller.dart';
import 'package:pharmacy/pages/filter_page/controller/filter_page_controller.dart';
import 'package:pharmacy/pages/filter_page/view/filter_page.dart';
import 'package:pharmacy/pages/main_page/controller/main_page_controller.dart';
import 'package:pharmacy/pages/main_page/view/main_page.dart';
import 'package:pharmacy/pages/shape_edit_page/controller/shape_edit_page_controller.dart';
import 'package:pharmacy/pages/shape_edit_page/view/shape_edit_page.dart';
import 'package:pharmacy/pages/shape_page/controller/shape_page_controller.dart';

class Routes {
  static String mainPage = '/main';
  static String editDrugPage = '/edit_drug';
  static String editCategoryPage = '/edit_category';
  static String editShapePage = '/edit_shape';
  static String filterPage = '/filter_page';
}

class Pages {
  static List<GetPage> pages = [
    GetPage(
      name: Routes.mainPage,
      page: () => const MainPage(),
      binding: MainBindings(),
    ),
    GetPage(
      name: Routes.editDrugPage,
      page: () => EditDrugPage(),
      binding: EditDrugBindings(),
    ),
    GetPage(
      name: Routes.editCategoryPage,
      page: () => const EditCategoryPage(),
      binding: EditCategoryBindings(),
    ),
    GetPage(
      name: Routes.editShapePage,
      page: () => const EditShapePage(),
      binding: EditShapeBindings(),
    ),
    GetPage(
      name: Routes.filterPage,
      page: () => FilterPage(),
      binding: FilterBindings(),
    ),
  ];
}

class MainBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MainPageController());
    Get.put(DrugPageController());
    Get.put(CategoryPageController());
    Get.put(ShapePageController());
    Get.put(BackupController());
  }
}

class EditDrugBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(EditDrugPageController());
  }
}

class EditCategoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(EditCategoryController());
  }
}

class EditShapeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(EditShapeController());
  }
}

class FilterBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(FilterPageController());
  }
}

routeToPage({required String page, Map? arguments, bool closeAllPreviousPages = false}) async {
  if (closeAllPreviousPages) {
    await Get.offAllNamed(page, arguments: arguments);
  } else {
    await Get.toNamed(page, arguments: arguments);
  }
}

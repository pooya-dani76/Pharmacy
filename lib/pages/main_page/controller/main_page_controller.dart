import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/backup_page/view/backup_page.dart';
import 'package:pharmacy/pages/category_page/controller/category_page_controller.dart';
import 'package:pharmacy/pages/category_page/view/category_page.dart';
import 'package:pharmacy/pages/drug_page/controller/drug_page_controller.dart';
import 'package:pharmacy/pages/drug_page/view/drug_page.dart';
import 'package:pharmacy/pages/shape_page/controller/shape_page_controller.dart';
import 'package:pharmacy/pages/shape_page/view/shape_page.dart';
import 'package:pharmacy/routes/routes.dart';

class MainPageController extends GetxController {
  int currentIndex = 0;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  setSearching(bool value) {
    isSearching = value;
    update();
  }

  setCurrentIndex(int index) {
    currentIndex = index;
    update();
  }

  search({required int currentIndex}) async {
    switch (currentIndex) {
      case 0:
        return searchDrugs(value: searchController.text);
      case 1:
        return searchCategories(value: searchController.text);
      case 2:
        return searchShapes(value: searchController.text);
    }
  }

  cancelSearch() {
    cancelSearchCategory();
    cancelSearchShape();
    cancelSearchDrug();
  }
}

bodySelector({required int currentIndex}) {
  switch (currentIndex) {
    case 0:
      return DrugPage();
    case 1:
      return CategoryPage();
    case 2:
      return ShapePage();
    case 3:
      return BackupPage();
  }
}

titleSelector({required int currentIndex}) {
  switch (currentIndex) {
    case 0:
      return 'دارو ها';
    case 1:
      return 'دسته بندی ها';
    case 2:
      return 'اشکال دارویی';
    case 3:
      return 'تنظیمات';
  }
}

routeSelector({required int currentIndex}) {
  switch (currentIndex) {
    case 0:
      return Routes.editDrugPage;
    case 1:
      return Routes.editCategoryPage;
    case 2:
      return Routes.editShapePage;
  }
}

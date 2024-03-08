// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data_base/models.dart';
import 'package:pharmacy/data_base/sqlit_storage.dart';
import 'package:pharmacy/pages/category_page/controller/category_page_controller.dart';
import 'package:pharmacy/pages/drug_edit_page/controller/drug_edit_page_controller.dart';
import 'package:pharmacy/pages/drug_page/controller/drug_page_controller.dart';
import 'package:pharmacy/pages/widgets/dialog.dart';
import 'package:pharmacy/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class EditCategoryController extends GetxController {
  bool isSubmitting = false;
  TextEditingController categoryNameController = TextEditingController();

  setIsSubmittingStatus(bool value) {
    isSubmitting = value;
    update();
  }

  saveCategory() async {
    setIsSubmittingStatus(true);
    Category category = Category(name: categoryNameController.text.trim());
    int result = await SqliteStorage.add(tableName: "DrugCategories", instance: category);
    if (result == 0) {
      Utils.showToast(message: "خطا در ثبت دسته بندی", isError: true);
    }
    setIsSubmittingStatus(false);
  }

  updateCategory({required Map category}) async {
    setIsSubmittingStatus(true);
    Category newCategory = Category(name: categoryNameController.text.trim(), id: category['id']);
    await SqliteStorage.update(tableName: "DrugCategories", instance: newCategory);
    setIsSubmittingStatus(false);
  }
}

putDataForUpdate(Map category) {
  EditCategoryController editCategoryController = Get.find<EditCategoryController>();
  editCategoryController.categoryNameController.text = category['name'];
}

onSubmitCategoryTap({Map? arguments}) async {
  EditCategoryController editCategoryController = Get.find<EditCategoryController>();
  CategoryPageController categoyPageController = Get.find<CategoryPageController>();
  DrugPageController drugPageController = Get.find<DrugPageController>();
  if (editCategoryController.categoryNameController.text.trim().isEmpty) {
    Utils.showToast(message: "نام دسته بندی نباید خالی باشد", isError: true);
  } else {
    if (arguments != null) {
      await editCategoryController.updateCategory(category: arguments['category']);
    } else {
      await editCategoryController.saveCategory();
    }
    try {
      EditDrugPageController editDrugPageController = Get.find<EditDrugPageController>();
      await editDrugPageController.updateSelectorItems(isCategory: true);
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
    }
    await categoyPageController.loader!.reload();
    await drugPageController.loader!.reload();
    Get.back();
  }
}

onDeleteCategoryTap({required BuildContext context, required Map category}) {
  openDialog(
      title: "آیا مطمنید می خواهید این دسته بندی را حذف کنید؟",
      onYesTap: () async {
        EditCategoryController editCategoryController = Get.find<EditCategoryController>();
        CategoryPageController categoyPageController = Get.find<CategoryPageController>();
        DrugPageController drugPageController = Get.find<DrugPageController>();
        editCategoryController.setIsSubmittingStatus(true);
        Get.back();
        Batch batch = await SqliteStorage.createDatabaseBatch();
        batch.delete("DrugCategories", where: "id = ?", whereArgs: [category['id']]);
        batch.delete("DrugToCategories", where: "category = ?", whereArgs: [category['id']]);
        await SqliteStorage.commitAll(batch: batch);
        await categoyPageController.loader!.reload();
        await drugPageController.loader!.reload();
        Get.back();
      },
      onNoTap: () => Get.back());
}

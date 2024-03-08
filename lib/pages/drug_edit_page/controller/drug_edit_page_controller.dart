// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data_base/models.dart';
import 'package:pharmacy/data_base/sqlit_storage.dart';
import 'package:pharmacy/pages/drug_page/controller/drug_page_controller.dart';
import 'package:pharmacy/pages/filter_page/controller/filter_page_controller.dart';
import 'package:pharmacy/pages/widgets/check_box_selector/controller/check_box_selector_controller.dart';
import 'package:pharmacy/pages/widgets/dialog.dart';
import 'package:pharmacy/routes/routes.dart';
import 'package:pharmacy/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class EditDrugPageController extends GetxController {
  Map? drugData;
  TextEditingController drugNameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController consumCaseController = TextEditingController();
  TextEditingController prohibitCasesController = TextEditingController();
  TextEditingController drugDisordersController = TextEditingController();
  TextEditingController foodDisordersController = TextEditingController();
  TextEditingController consumRolesController = TextEditingController();
  TextEditingController descriptionsController = TextEditingController();
  CheckBoxSelectorController? categorySelectorController;
  CheckBoxSelectorController? shapeSelectorController;
  bool isSubmitting = false;

  preLoads() async {
    await getSelectorsData().then((res) => putDrugDataForUpdate());
  }

  putDrugDataForUpdate() async {
    Batch batch = await SqliteStorage.createDatabaseBatch();
    batch.rawQuery("""
    Select DrugCategories.name, DrugCategories.id from Drugs
    INNER JOIN DrugToCategories on Drugs.id=DrugToCategories.drug
    INNER JOIN DrugCategories on DrugToCategories.category=DrugCategories.id
    WHERE Drugs.id = ?
    """, [drugData!['id']]);
    batch.rawQuery("""
    Select DrugShapes.name, DrugShapes.id from Drugs
    INNER JOIN DrugToShapes on Drugs.id=DrugToShapes.drug
    INNER JOIN DrugShapes on DrugToShapes.shape=DrugShapes.id
    WHERE Drugs.id = ?
    """, [drugData!['id']]);
    List result = await SqliteStorage.commitAll(batch: batch);
    drugNameController.text = drugData!['name'];
    dosageController.text = drugData!['dosage'].toString();
    consumCaseController.text = drugData!['consum_cases'];
    prohibitCasesController.text = drugData!['prohibit_cases'];
    drugDisordersController.text = drugData!['drug_disorders'];
    foodDisordersController.text = drugData!['food_disorders'];
    consumRolesController.text = drugData!['consum_roles'];
    descriptionsController.text = drugData!['descriptions'];
    categorySelectorController!.setSelecteds(result[0].toList());
    shapeSelectorController!.setSelecteds(result[1].toList());
    update();
  }

  updateSelectorItems({required bool isCategory}) async {
    // if (isCategory) {
    //   List categories = await SqliteStorage.getAll(tableName: "DrugCategories");
    //   categorySelectorController!.items = categories;
    // } else {
    //   List shapes = await SqliteStorage.getAll(tableName: "DrugShapes");
    //   shapeSelectorController!.items = shapes;
    // }
    update();
  }

  setIsSubmittingStatus(bool value) {
    isSubmitting = value;
    update();
  }

  getSelectorsData() async {
    categorySelectorController = CheckBoxSelectorController(
        query: """SELECT * FROM DrugCategories""",
        title: "دسته بندی ها",
        onAddTap: () => routeToPage(
              page: Routes.editCategoryPage,
            ),
        afterDone: () => update());
    shapeSelectorController = CheckBoxSelectorController(
        query: """SELECT * FROM DrugShapes""",
        title: "اشکال دارویی",
        onAddTap: () => routeToPage(
              page: Routes.editShapePage,
            ),
        afterDone: () => update());
    update();
  }

  Drug createInstance({int? drugId}) {
    Drug drug = Drug(
      id: drugId,
      name: drugNameController.text,
      dosage: dosageController.text,
      consumCases: consumCaseController.text,
      prohibitCases: prohibitCasesController.text,
      drugDisorders: drugDisordersController.text,
      foodDisorders: foodDisordersController.text,
      consumRoles: consumRolesController.text,
      descriptions: descriptionsController.text,
    );
    return drug;
  }

  Batch insertCategories({required int drugId, required Batch batch}) {
    for (var element in categorySelectorController!.selectedIds) {
      DrugToCategory drugToCategory = DrugToCategory(drug: drugId, category: element);
      batch.insert("DrugToCategories", drugToCategory.toMap());
    }
    return batch;
  }

  Batch insertShapes({required int drugId, required Batch batch}) {
    for (var element in shapeSelectorController!.selectedIds) {
      DrugToShape drugToShape = DrugToShape(drug: drugId, shape: element);
      batch.insert("DrugToShapes", drugToShape.toMap());
    }
    return batch;
  }

  saveData() async {
    DrugPageController drugPageController = Get.find<DrugPageController>();
    setIsSubmittingStatus(true);
    Drug drug = createInstance();
    int insertedId = await SqliteStorage.add(tableName: 'Drugs', instance: drug);
    if (insertedId != 0) {
      Batch batch = await SqliteStorage.createDatabaseBatch();
      batch = insertCategories(drugId: insertedId, batch: batch);
      batch = insertShapes(drugId: insertedId, batch: batch);
      await SqliteStorage.commitAll(batch: batch);
      setIsSubmittingStatus(false);
      await drugPageController.loader!.reload();
      Get.back();
    } else {
      Utils.showToast(
        message: "خطایی در ذخیره سازی دارو بوجود آمد",
        isError: true,
      );
    }
  }

  updateData({required int drugId}) async {
    DrugPageController drugPageController = Get.find<DrugPageController>();
    setIsSubmittingStatus(true);
    Drug drug = createInstance(drugId: drugId);
    Batch batch = await SqliteStorage.createDatabaseBatch();
    batch.update("Drugs", drug.toMap(), where: "id = ?", whereArgs: [drug.id]);
    batch.delete("DrugToCategories", where: "drug = ?", whereArgs: [drug.id]);
    batch.delete("DrugToShapes", where: "drug = ?", whereArgs: [drug.id]);
    for (var categoryId in categorySelectorController!.selectedIds) {
      DrugToCategory drugToCategory = DrugToCategory(drug: drug.id!, category: categoryId);
      batch.insert("DrugToCategories", drugToCategory.toMap());
    }
    for (var shapeId in shapeSelectorController!.selectedIds) {
      DrugToShape drugToShape = DrugToShape(drug: drug.id!, shape: shapeId);
      batch.insert("DrugToShapes", drugToShape.toMap());
    }
    await SqliteStorage.commitAll(batch: batch);
    setIsSubmittingStatus(false);
    await drugPageController.loader!.reload();
    try {
      FilterPageController filterPageController = Get.find<FilterPageController>();
      await filterPageController.loader!.reload();
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
    }
    Get.back();
  }

  onDrugSubmitButtonTap({Map? arguments}) async {
    if (drugNameController.text.trim().isEmpty ||
        categorySelectorController!.selectedIds.isEmpty ||
        shapeSelectorController!.selectedIds.isEmpty) {
      Utils.showToast(
          message: "فیلد های نام دارو، دسته بندی ها و اشکال دارویی نباید خالی باشد", isError: true);
    } else {
      if (arguments != null) {
        await updateData(drugId: arguments['id']);
      } else {
        await saveData();
      }
    }
  }
}

onDeleteDrugTap({required Map drug}) {
  openDialog(
      title: "آیا مطمنید می خواهید این دارو را حذف کنید؟",
      onYesTap: () async {
        EditDrugPageController editDrugPageController = Get.find<EditDrugPageController>();
        DrugPageController drugPageController = Get.find<DrugPageController>();
        editDrugPageController.setIsSubmittingStatus(true);
        Get.back();
        Batch batch = await SqliteStorage.createDatabaseBatch();
        batch.delete("DrugToCategories", where: "drug = ?", whereArgs: [drug['id']]);
        batch.delete("DrugToShapes", where: "drug = ?", whereArgs: [drug['id']]);
        batch.delete("Drugs", where: "id = ?", whereArgs: [drug['id']]);
        await SqliteStorage.commitAll(batch: batch);
        await drugPageController.loader!.reload();
        Get.back();
      },
      onNoTap: () => Get.back());
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data_base/models.dart';
import 'package:pharmacy/data_base/sqlit_storage.dart';
import 'package:pharmacy/pages/drug_edit_page/controller/drug_edit_page_controller.dart';
import 'package:pharmacy/pages/main_page/controller/main_page_controller.dart';
import 'package:pharmacy/pages/shape_page/controller/shape_page_controller.dart';
import 'package:pharmacy/pages/widgets/dialog.dart';
import 'package:pharmacy/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class EditShapeController extends GetxController {
  bool isSubmitting = false;
  TextEditingController shapeNameController = TextEditingController();

  setIsSubmittingStatus(bool value) {
    isSubmitting = value;
    update();
  }

  saveShape() async {
    setIsSubmittingStatus(true);
    Shape shape = Shape(name: shapeNameController.text.trim());
    int result = await SqliteStorage.add(tableName: "DrugShapes", instance: shape);
    if (result == 0) {
      Utils.showToast(message: "خطا در ثبت شکل دارویی", isError: true);
    }
    setIsSubmittingStatus(false);
  }

  updateShape({required Map shape}) async {
    setIsSubmittingStatus(true);
    Shape newShape = Shape(name: shapeNameController.text.trim(), id: shape['id']);
    await SqliteStorage.update(tableName: "DrugShapes", instance: newShape);
    setIsSubmittingStatus(false);
  }
}

putShapeDataForUpdate(Map shape) {
  EditShapeController editShapeController = Get.find<EditShapeController>();
  editShapeController.shapeNameController.text = shape['name'];
}

onSubmitShapeTap({Map? arguments}) async {
  EditShapeController editShapeController = Get.find<EditShapeController>();
  MainPageController mainPageController = Get.find<MainPageController>();
  ShapePageController shapePageController = Get.find<ShapePageController>();

  if (editShapeController.shapeNameController.text.trim().isEmpty) {
    Utils.showToast(message: "نام شکل دارویی نباید خالی باشد", isError: true);
  } else {
    if (arguments != null) {
      await editShapeController.updateShape(shape: arguments['shape']);
    } else {
      await editShapeController.saveShape();
    }
    try {
      EditDrugPageController editDrugPageController = Get.find<EditDrugPageController>();
      await editDrugPageController.updateSelectorItems(isCategory: false);
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
    }
    await shapePageController.loader!.reload();
    await mainPageController.setBadges();
    Get.back();
  }
}

onDeleteShapeTap({required BuildContext context, required Map shape}) {
  openDialog(
      title: "آیا مطمنید می خواهید این شکل دارویی را حذف کنید؟",
      onYesTap: () async {
        EditShapeController editShapeController = Get.find<EditShapeController>();
        ShapePageController shapePageController = Get.find<ShapePageController>();
        MainPageController mainPageController = Get.find<MainPageController>();
        editShapeController.setIsSubmittingStatus(true);
        Get.back();
        Batch batch = await SqliteStorage.createDatabaseBatch();
        batch.delete("DrugShapes", where: "id = ?", whereArgs: [shape['id']]);
        batch.delete("DrugToShapes", where: "shape = ?", whereArgs: [shape['id']]);
        await SqliteStorage.commitAll(batch: batch);
        await shapePageController.loader!.reload();
        await mainPageController.setBadges();
        Get.back();
      },
      onNoTap: () => Get.back());
}

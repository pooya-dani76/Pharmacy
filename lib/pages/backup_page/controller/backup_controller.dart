import 'package:get/get.dart';
import 'package:pharmacy/data_base/sqlit_storage.dart';
import 'package:pharmacy/pages/category_page/controller/category_page_controller.dart';
import 'package:pharmacy/pages/drug_page/controller/drug_page_controller.dart';
import 'package:pharmacy/pages/shape_page/controller/shape_page_controller.dart';
import 'package:pharmacy/utils/utils.dart';

class BackupController extends GetxController {
  bool isProcessing = false;

  setIsProcessing(bool value) {
    isProcessing = value;
    update();
  }
}

onBackupTap() {
  BackupController backupController = Get.find<BackupController>();
  backupController.setIsProcessing(true);
  SqliteStorage.backupDataBase();
  backupController.setIsProcessing(false);
}

onRestoreTap() async {
  BackupController backupController = Get.find<BackupController>();
  DrugPageController drugPageController = Get.find<DrugPageController>();
  ShapePageController shapePageController = Get.find<ShapePageController>();
  CategoryPageController categoryPageController = Get.find<CategoryPageController>();
  backupController.setIsProcessing(true);
  await SqliteStorage.restoreDatabase();
  Utils.showToast(message: "بازگردانی با موفقیت انجام شد", isError: false);
  await drugPageController.loader!.reload();
  await shapePageController.loader!.reload();
  await categoryPageController.loader!.reload();
  backupController.setIsProcessing(false);
}

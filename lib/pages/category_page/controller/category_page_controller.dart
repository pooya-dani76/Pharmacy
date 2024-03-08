// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'package:pharmacy/pages/widgets/lazy_load/lazy_load.dart';

class CategoryPageController extends GetxController {
  @override
  void onInit() {
    loader = LazyLoad(
      sqlCommands: [
        """
        Select * from DrugCategories ORDER BY name
        """
      ],
      afterLoad: () {},
    );
    loader!.afterLoad = () => update();
    super.onInit();
  }
  LazyLoad? loader;
}

searchCategories({required String value}) async {
  CategoryPageController categoyPageController = Get.find<CategoryPageController>();
  categoyPageController.loader = null;
  categoyPageController.update();
  categoyPageController.loader = LazyLoad(
      sqlCommands: [
        """
        Select * from DrugCategories Where name Like "%$value%" ORDER BY name
        """
      ],
      afterLoad: () => categoyPageController.update(),
    );
}

cancelSearchCategory(){
  CategoryPageController categoyPageController = Get.find<CategoryPageController>();
  categoyPageController.loader = null;
  categoyPageController.update();
  categoyPageController.loader = LazyLoad(
      sqlCommands: [
        """
        Select * from DrugCategories ORDER BY name
        """
      ],
      afterLoad: () => categoyPageController.update(),
    );
}

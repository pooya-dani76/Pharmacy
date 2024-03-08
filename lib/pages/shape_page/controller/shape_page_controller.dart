// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'package:pharmacy/pages/widgets/lazy_load/lazy_load.dart';

class ShapePageController extends GetxController {
  @override
  void onInit() {
    loader = LazyLoad(
      sqlCommands: [
        """
        Select * from DrugShapes ORDER BY name
        """
      ],
      afterLoad: () {},
    );
    loader!.afterLoad = () => update();
    super.onInit();
  }
  LazyLoad? loader;
}

searchShapes({required String value}) async {
  ShapePageController shapePageController = Get.find<ShapePageController>();
  shapePageController.loader = null;
  shapePageController.update();
  shapePageController.loader = LazyLoad(
      sqlCommands: [
        """
        Select * from DrugShapes Where name Like "%$value%" ORDER BY name
        """
      ],
      afterLoad: () => shapePageController.update(),
    );
}

cancelSearchShape(){
  ShapePageController shapePageController = Get.find<ShapePageController>();
  shapePageController.loader = null;
  shapePageController.update();
  shapePageController.loader = LazyLoad(
      sqlCommands: [
        """
        Select * from DrugShapes ORDER BY name
        """
      ],
      afterLoad: () => shapePageController.update(),
    );
}

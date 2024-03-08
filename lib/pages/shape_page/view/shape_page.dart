// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/shape_page/controller/shape_page_controller.dart';
import 'package:pharmacy/pages/widgets/custom_list_tile.dart';
import 'package:pharmacy/pages/widgets/loading_progress.dart';
import 'package:pharmacy/pages/widgets/text.dart';
import 'package:pharmacy/routes/routes.dart';

class ShapePage extends StatelessWidget {
  ShapePage({super.key});

  ShapePageController shapePageController = Get.find<ShapePageController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShapePageController>(
      builder: (controller) {
        if (controller.loader != null) {
          return controller.loader!.listView(
            itemBuilder: (context, index) {
              return CustomListTile(
                onTap: () => routeToPage(
                    page: Routes.filterPage,
                    arguments: {'shape': controller.loader!.data[0][index]}),
                onEditTap: () => routeToPage(
                    page: Routes.editShapePage,
                    arguments: {"shape": controller.loader!.data[0][index]}),
                title: CustomText(
                    text: controller.loader!.data[0][index]['name'], fontWeight: FontWeight.bold),
              );
            },
          );
        } else {
          return const Center(child: LoadingProgress());
        }
      },
    );
  }
}

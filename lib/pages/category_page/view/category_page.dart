// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/category_page/controller/category_page_controller.dart';
import 'package:pharmacy/pages/widgets/custom_list_tile.dart';
import 'package:pharmacy/pages/widgets/loading_progress.dart';
import 'package:pharmacy/pages/widgets/text.dart';
import 'package:pharmacy/routes/routes.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  CategoryPageController categoyPageController = Get.find<CategoryPageController>();

  @override
  Widget build(BuildContext context) {
    // categoyPageController.getCategoryData();
    return GetBuilder<CategoryPageController>(
      builder: (controller) {
        if (controller.loader != null) {
          return controller.loader!.listView(
            itemBuilder: (context, index) {
              return CustomListTile(
                index: index + 1,
                onTap: () => routeToPage(
                    page: Routes.filterPage,
                    arguments: {'category': controller.loader!.data[0][index]}),
                onEditTap: () => routeToPage(
                    page: Routes.editCategoryPage,
                    arguments: {"category": controller.loader!.data[0][index]}),
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

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/app_controller/app_controller.dart';
import 'package:pharmacy/pages/drug_page/controller/drug_page_controller.dart';
import 'package:pharmacy/pages/widgets/custom_list_tile.dart';
import 'package:pharmacy/pages/widgets/loading_progress.dart';
import 'package:pharmacy/pages/widgets/text.dart';
import 'package:pharmacy/routes/routes.dart';

class DrugPage extends StatelessWidget {
  DrugPage({super.key});

  DrugPageController drugPageController = Get.find<DrugPageController>();
  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DrugPageController>(
      builder: (controller) {
        if (controller.loader != null) {
          return controller.loader!.listView(itemBuilder: (context, index) {
            return CustomListTile(
              index: index + 1,
              onTap: () => routeToPage(
                  page: Routes.editDrugPage,
                  arguments: {"drug_data": controller.loader!.data[0][index]}),
              title: CustomText(
                  text: controller.loader!.data[0][index]['name'], fontWeight: FontWeight.bold),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 5,
                    children: controller.loader!.data[0][index]['categories']
                        .split('#')
                        .map<Widget>((element) => Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: appController.appColor,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    text: element,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                            )).toList()),
              ),
            );
          });
        } else {
          return const Center(child: LoadingProgress());
        }
      },
    );
  }
}

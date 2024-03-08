// ignore_for_file: prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/app_controller/app_controller.dart';
import 'package:pharmacy/pages/filter_page/controller/filter_page_controller.dart';
import 'package:pharmacy/pages/widgets/appbar.dart';
import 'package:pharmacy/pages/widgets/custom_list_tile.dart';
import 'package:pharmacy/pages/widgets/loading_progress.dart';
import 'package:pharmacy/pages/widgets/text.dart';
import 'package:pharmacy/routes/routes.dart';

class FilterPage extends StatelessWidget {
  FilterPage({super.key});

  FilterPageController filterPageController = Get.find<FilterPageController>();
  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    filterPageController.loadData(getArguments: Get.arguments);
    return Scaffold(
      appBar: CustomAppBar(
          title: "دارو هایی با"
                  " " +
              titleNames[Get.arguments.keys.toList()[0]] +
              " " +
              Get.arguments[Get.arguments.keys.toList()[0]]['name']),
      body: GetBuilder<FilterPageController>(
        builder: (controller) {
          if (controller.loader != null) {
          return controller.loader!.listView(itemBuilder: (context, index) {
                return CustomListTile(
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
                      children: controller.loader!.data[1]
                          .where((element) => element['id'] == controller.loader!.data[0][index]['id'])
                          .map<Widget>((item) => Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: appController.appColor
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      text: item["category"],
                                      fontWeight: FontWeight.bold,
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                );
              });
        } else {
          return const Center(child: LoadingProgress());
        }
        },
      ),
    );
  }
}

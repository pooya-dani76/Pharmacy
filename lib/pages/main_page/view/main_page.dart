// ignore_for_file: must_be_immutable

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/app_controller/app_controller.dart';
import 'package:pharmacy/pages/main_page/controller/main_page_controller.dart';
import 'package:pharmacy/pages/widgets/appbar.dart';
import 'package:pharmacy/pages/widgets/custom_fab.dart';
import 'package:pharmacy/pages/widgets/text.dart';
import 'package:pharmacy/routes/routes.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (appController) {
        return GetBuilder<MainPageController>(builder: (controller) {
          return Scaffold(
            bottomNavigationBar: CustomNavigationBar(
              selectedColor: appController.appColor,
              unSelectedColor: Colors.grey,
              bubbleCurve: Curves.bounceInOut,
              currentIndex: controller.currentIndex,
              onTap: (int index) => controller.setCurrentIndex(index),
              items: [
                CustomNavigationBarItem(
                  icon: Badge(
                    backgroundColor: appController.appColor,
                    offset: const Offset(-20, -4),
                    label: Text(controller.drugBadge.toString()),
                    textStyle: const TextStyle(fontFamily: "Vazir", fontSize: 12),
                    child: SvgPicture.asset(
                      "assets/images/drugs.svg",
                      colorFilter: ColorFilter.mode(
                          controller.currentIndex == 0 ? appController.appColor : Colors.grey,
                          BlendMode.srcIn),
                    ),
                  ),
                  title: CustomText(
                    text: "دارو",
                    color: controller.currentIndex == 0 ? appController.appColor : Colors.grey,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: Badge(
                    backgroundColor: appController.appColor,
                    offset: const Offset(-20, -4),
                    label: Text(controller.categoryBadge.toString()),
                    textStyle: const TextStyle(fontFamily: "Vazir", fontSize: 12),
                    child: SvgPicture.asset(
                      "assets/images/categories.svg",
                      colorFilter: ColorFilter.mode(
                          controller.currentIndex == 1 ? appController.appColor : Colors.grey,
                          BlendMode.srcIn),
                    ),
                  ),
                  title: CustomText(
                    text: "دسته بندی",
                    color: controller.currentIndex == 1 ? appController.appColor : Colors.grey,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: Badge(
                    backgroundColor: appController.appColor,
                    offset: const Offset(-20, -4),
                    label: Text(controller.shapeBadge.toString()),
                    textStyle: const TextStyle(fontFamily: "Vazir", fontSize: 12),
                    child: SvgPicture.asset(
                      "assets/images/shapes.svg",
                      colorFilter: ColorFilter.mode(
                          controller.currentIndex == 2 ? appController.appColor : Colors.grey,
                          BlendMode.srcIn),
                    ),
                  ),
                  title: CustomText(
                    text: "اشکال دارویی",
                    color: controller.currentIndex == 2 ? appController.appColor : Colors.grey,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/setting.svg",
                    colorFilter: ColorFilter.mode(
                        controller.currentIndex == 3 ? appController.appColor : Colors.grey,
                        BlendMode.srcIn),
                  ),
                  title: CustomText(
                    text: "تنظیمات",
                    color: controller.currentIndex == 3 ? appController.appColor : Colors.grey,
                  ),
                ),
              ],
            ),
            floatingActionButton: controller.currentIndex != 3
                ? CustomFAB(
                    icon: Icons.add_rounded,
                    onTap: () =>
                        routeToPage(page: routeSelector(currentIndex: controller.currentIndex)),
                  )
                : null,
            appBar: CustomAppBar(
                actions: controller.currentIndex == 3
                    ? null
                    : (controller.isSearching
                        ? [
                            IconButton(
                                onPressed: () {
                                  controller.cancelSearch();
                                  controller.setSearching(false);
                                  controller.searchController.clear();
                                },
                                icon: const Icon(Icons.close)),
                          ]
                        : [
                            IconButton(
                                onPressed: () => controller.setSearching(true),
                                icon: const Icon(Icons.search)),
                          ]),
                title: titleSelector(currentIndex: controller.currentIndex)),
            body: bodySelector(currentIndex: controller.currentIndex),
          );
        });
      },
    );
  }
}

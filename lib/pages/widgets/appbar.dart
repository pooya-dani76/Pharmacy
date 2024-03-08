// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/main_page/controller/main_page_controller.dart';
import 'package:pharmacy/pages/widgets/text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.actions,
    required this.title,
    this.showSearchBar = true,
  });

  final List<Widget>? actions;
  final bool? showSearchBar;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainPageController>(builder: (controller) {
      return AppBar(
        title: controller.isSearching & showSearchBar!
            ? TextField(
                controller: controller.searchController,
                cursorColor: Colors.white,
                style: const TextStyle(fontFamily: "Vazir", color: Colors.white),
                onChanged: (value) => Future.delayed(
                  const Duration(milliseconds: 500),
                  () {
                    if (controller.searchController.text == value) {
                      controller.search(currentIndex: controller.currentIndex);
                    }
                  },
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  isCollapsed: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            : Container(
                margin: const EdgeInsets.all(8.0),
                child: CustomText(
                  text: title,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
        centerTitle: true,
        actions: actions,
      );
    });
  }

  @override
  Size get preferredSize => Size(Get.width, 60);
}

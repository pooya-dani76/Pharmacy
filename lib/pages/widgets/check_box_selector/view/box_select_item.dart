// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/app_controller/app_controller.dart';
import 'package:pharmacy/pages/widgets/text.dart';

class BoxSelectItem extends StatelessWidget {
   BoxSelectItem({
    super.key,
    required this.onDelete,
    required this.name,
  });

  final Function onDelete;
  final String name;

  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: Center(
              child: InkWell(
                  onTap: () => onDelete(),
                  child: const Icon(Icons.close, color: Colors.red, size: 15)),
            ),
          ),
          const SizedBox(width: 8),
          CustomText(
            text: name,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}

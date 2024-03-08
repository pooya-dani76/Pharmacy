// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/app_controller/app_controller.dart';
import 'package:pharmacy/pages/widgets/text.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key, required this.title, required this.onTap, this.color});

  final String title;
  final Function onTap;
  final Color? color;
  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(color: color ?? appController.appColor, width: 3),
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: CustomText(
            text: title,
            color: color ?? appController.appColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/app_controller/app_controller.dart';
import 'package:pharmacy/pages/backup_page/controller/backup_controller.dart';
import 'package:pharmacy/pages/widgets/custom_button.dart';
import 'package:pharmacy/pages/widgets/loading_progress.dart';
import 'package:pharmacy/pages/widgets/text.dart';

class BackupPage extends StatelessWidget {
  BackupPage({super.key});

  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BackupController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const CustomText(text: "تم ها", fontWeight: FontWeight.bold),
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                spacing: 10,
                runSpacing: 8,
                children: appController.colors
                    .map<Widget>(
                      (color) => InkWell(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: ()=> appController.setThemeColor(newAppColor: color),
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                          height: 30,
                          width: 30,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 30),
              if (controller.isProcessing) ...{
                const Center(child: LoadingProgress())
              } else ...{
                CustomButton(title: "پشتیبان گیری", onTap: () => onBackupTap()),
                const SizedBox(height: 30),
                CustomButton(title: "بازگردانی", onTap: () => onRestoreTap()),
              }
            ],
          ),
        );
      },
    );
  }
}

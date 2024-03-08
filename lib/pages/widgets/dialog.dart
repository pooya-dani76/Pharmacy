import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/widgets/custom_button.dart';

openDialog({required String title, required Function onYesTap, required onNoTap}) async {
  await Get.defaultDialog(
    titlePadding: const EdgeInsets.all(10),
    contentPadding: const EdgeInsets.all(10),
    title: title,
    titleStyle: const TextStyle(fontSize: 16),
    content: Row(
      children: [
        Expanded(
            child: CustomButton(
          title: "بله",
          color: Colors.red,
          onTap: onYesTap,
        )),
        const SizedBox(width: 10),
        Expanded(child: CustomButton(title: 'خیر', onTap: onNoTap)),
      ],
    ),
  );
}

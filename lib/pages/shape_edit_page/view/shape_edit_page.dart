import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/shape_edit_page/controller/shape_edit_page_controller.dart';
import 'package:pharmacy/pages/widgets/appbar.dart';
import 'package:pharmacy/pages/widgets/custom_button.dart';
import 'package:pharmacy/pages/widgets/custom_text_field.dart';
import 'package:pharmacy/pages/widgets/loading_progress.dart';

class EditShapePage extends StatelessWidget {
  const EditShapePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      putShapeDataForUpdate(Get.arguments['shape']);
    }
    return Scaffold(
      appBar: CustomAppBar(
          title: Get.arguments != null ? "ویرایش شکل دارویی" : "افزودن شکل دارویی"),
      body: GetBuilder<EditShapeController>(
        builder: (controller) {
          return ListView(
            padding: const EdgeInsets.all(10),
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                controller: controller.shapeNameController,
                label: "نام شکل دارویی",
              ),
              const SizedBox(height: 20),
              if (controller.isSubmitting) ...{
                const Center(child: LoadingProgress())
              } else ...{
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: "ثبت",
                        onTap: () => onSubmitShapeTap(arguments: Get.arguments),
                      ),
                    ),
                    if (Get.arguments != null) ...{
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          title: "حذف",
                          color: Colors.red,
                          onTap: () => onDeleteShapeTap(
                            context: context,
                            shape: Get.arguments['shape'],
                          ),
                        ),
                      ),
                    }
                  ],
                )
              }
            ],
          );
        },
      ),
    );
  }
}

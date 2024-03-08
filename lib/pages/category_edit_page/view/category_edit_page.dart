import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/category_edit_page/controller/category_edit_controller.dart';
import 'package:pharmacy/pages/widgets/appbar.dart';
import 'package:pharmacy/pages/widgets/custom_button.dart';
import 'package:pharmacy/pages/widgets/custom_text_field.dart';
import 'package:pharmacy/pages/widgets/loading_progress.dart';

class EditCategoryPage extends StatelessWidget {
  const EditCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      putDataForUpdate(Get.arguments['category']);
    }
    return Scaffold(
      appBar: CustomAppBar(
          title: Get.arguments != null ? "ویرایش دسته بندی" : "افزودن دسته بندی"),
      body: GetBuilder<EditCategoryController>(
        builder: (controller) {
          return ListView(
            padding: const EdgeInsets.all(10),
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                controller: controller.categoryNameController,
                label: "نام دسته بندی",
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
                        onTap: () => onSubmitCategoryTap(
                          arguments: Get.arguments,
                        ),
                      ),
                    ),
                    if (Get.arguments != null) ...{
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          title: "حذف",
                          color: Colors.red,
                          onTap: () => onDeleteCategoryTap(
                            context: context,
                            category: Get.arguments['category'],
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

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/drug_edit_page/controller/drug_edit_page_controller.dart';
import 'package:pharmacy/pages/widgets/appbar.dart';
import 'package:pharmacy/pages/widgets/check_box_selector/view/check_box_selector.dart';
import 'package:pharmacy/pages/widgets/custom_button.dart';
import 'package:pharmacy/pages/widgets/custom_text_field.dart';
import 'package:pharmacy/pages/widgets/loading_progress.dart';

class EditDrugPage extends StatelessWidget {
  EditDrugPage({super.key});

  EditDrugPageController editDrugPageController = Get.put(EditDrugPageController());

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      editDrugPageController.drugData = Get.arguments['drug_data'];
      editDrugPageController.preLoads();
    } else {
      editDrugPageController.getSelectorsData();
    }
    return Scaffold(
      appBar: CustomAppBar(
        showSearchBar: false,
        title: editDrugPageController.drugData != null ? "ویرایش دارو" : "افزودن دارو",
        actions: [
          if (editDrugPageController.isSubmitting) ...{
            const Center(child: LoadingProgress())
          } else ...{
            Row(
              children: [
                if (editDrugPageController.drugData != null) ...{
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () => onDeleteDrugTap(drug: editDrugPageController.drugData!),
                  ),
                },
                IconButton(
                  icon: const Icon(Icons.check_rounded),
                  onPressed: () => editDrugPageController.onDrugSubmitButtonTap(
                    arguments: editDrugPageController.drugData,
                  ),
                ),
              ],
            )
          }
        ],
      ),
      body: GetBuilder<EditDrugPageController>(builder: (controller) {
        if (controller.categorySelectorController != null) {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                const SizedBox(height: 20),
                CustomTextField(
                  controller: controller.drugNameController,
                  label: "نام دارو",
                ),
                const SizedBox(height: 20),
                CheckBoxSelector(controller: controller.categorySelectorController!),
                const SizedBox(height: 20),
                CheckBoxSelector(controller: controller.shapeSelectorController!),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: controller.dosageController,
                  label: "دوز",
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: controller.consumCaseController,
                  maxLines: 5,
                  label: "موارد مصرف",
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: controller.consumRolesController,
                  maxLines: 5,
                  label: "دستور مصرف",
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: controller.prohibitCasesController,
                  maxLines: 5,
                  label: "موارد منع مصرف",
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: controller.drugDisordersController,
                  maxLines: 5,
                  label: "تداخلات دارویی",
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: controller.foodDisordersController,
                  maxLines: 5,
                  label: "تداخلات خوراکی",
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: controller.descriptionsController,
                  maxLines: 5,
                  label: "سایر توضیحات",
                ),
                const SizedBox(height: 20),
                if (editDrugPageController.isSubmitting) ...{
                  const Center(child: LoadingProgress())
                } else ...{
                  Row(
                    children: [
                      if (editDrugPageController.drugData != null) ...{
                        Expanded(
                          child: CustomButton(
                            title: "حذف",
                            color: Colors.red,
                            onTap: () => onDeleteDrugTap(drug: editDrugPageController.drugData!),
                          ),
                        ),
                        const SizedBox(width: 10),
                      },
                      Expanded(
                        child: CustomButton(
                          title: "ثبت",
                          onTap: () => editDrugPageController.onDrugSubmitButtonTap(
                            arguments: editDrugPageController.drugData,
                          ),
                        ),
                      ),
                    ],
                  )
                }
              ],
            );
          // } else {
          //   return const Center(
          //       child: CustomText(
          //     text: "ابتدا باید حداقل یک دسته بندی و یک شکل دارویی موجود باشد",
          //     fontWeight: FontWeight.bold,
          //     textAlign: TextAlign.center,
          //     maxLine: 2,
          //   ));
          // }
        } else {
          return const Center(child: LoadingProgress());
        }
      }),
    );
  }
}

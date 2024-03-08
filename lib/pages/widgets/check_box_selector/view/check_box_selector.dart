import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/widgets/check_box_selector/controller/check_box_selector_controller.dart';
import 'package:pharmacy/pages/widgets/check_box_selector/view/box_select_item.dart';
import 'package:pharmacy/pages/widgets/text.dart';

class CheckBoxSelector extends StatelessWidget {
  const CheckBoxSelector({
    super.key,
    required this.controller,
  });

  final CheckBoxSelectorController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: CustomText(
            text: controller.title,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => controller.openDialog(),
          borderRadius: BorderRadius.circular(10),
          child: DottedBorder(
            borderType: BorderType.RRect,
            color: Colors.grey,
            radius: const Radius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(5),
              constraints: BoxConstraints(minHeight: 50, minWidth: Get.width),
              child: controller.selectedItems.isNotEmpty
                  ? Wrap(
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.selecteds
                          .map(
                            (item) => BoxSelectItem(
                              name: item['name'],
                              onDelete: () => controller.removeItem(item),
                            ),
                          )
                          .toList(),
                    )
                  : Row(
                      children: [
                        const SizedBox(width: 10),
                        const Icon(Icons.add_circle_outline_rounded, color: Colors.grey),
                        const SizedBox(width: 10),
                        CustomText(text: controller.title, color: Colors.grey)
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

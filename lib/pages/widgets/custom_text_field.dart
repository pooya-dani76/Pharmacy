import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmacy/pages/app_controller/app_controller.dart';
import 'package:pharmacy/pages/widgets/text.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.maxLines,
    this.maxLength,
    this.label,
    this.onlyNumeric = false,
    this.cursorColor,
    this.inputDecoration,
    this.onChanged,
  });

  final TextEditingController controller;
  final int? maxLines;
  final int? maxLength;
  final String? label;
  final bool? onlyNumeric;
  final Color? cursorColor;
  final InputDecoration? inputDecoration;
  final Function(String)? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode focus = FocusNode();
  late bool focused;

  AppController appController = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    focus.addListener(onFocusChange);
    focused = false;
  }

  @override
  void dispose() {
    super.dispose();
    focus.removeListener(onFocusChange);
    focus.dispose();
  }

  void onFocusChange() {
    setState(() {
      focused = focus.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...{
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: CustomText(
              text: widget.label!,
              fontWeight: FontWeight.bold,
              color: focused ? appController.appColor : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
        },
        TextField(
            focusNode: focus,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            keyboardType: widget.onlyNumeric! ? TextInputType.number : null,
            inputFormatters: widget.onlyNumeric! ? [FilteringTextInputFormatter.digitsOnly] : null,
            cursorColor: widget.cursorColor ?? appController.appColor,
            controller: widget.controller,
            style: const TextStyle(fontFamily: "Vazir"),
            onChanged: widget.onChanged),
      ],
    );
  }
}

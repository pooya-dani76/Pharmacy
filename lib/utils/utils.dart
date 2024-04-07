import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pharmacy/pages/widgets/text.dart';

enum LogType { trace, debug, info, warning, error }

class Utils {
  static void logEvent({required String message, required LogType logType}) {
    Logger logger = Logger();
    switch (logType) {
      case LogType.trace:
        logger.t(message);
        break;
      case LogType.debug:
        logger.d(message);
        break;
      case LogType.info:
        logger.i(message);
        break;
      case LogType.warning:
        logger.w(message);
        break;
      case LogType.error:
        logger.e(message);
        break;
    }
  }

  static showToast({
    required String message,
    required bool isError,
  }) async {
    await Flushbar(
      isDismissible: true,
      messageText: Directionality(
          textDirection: TextDirection.rtl,
          child: CustomText(
            text: message,
            maxLine: 2,
            fontSize: 12,
            color: Colors.white,
          )),
      icon: Icon(
        isError ? Icons.dangerous_outlined : Icons.done_rounded,
        size: 28.0,
        color: isError ? Colors.red : Colors.green,
      ),
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: isError ? Colors.red : Colors.green,
    ).show(Get.context!);
  }

  static Map tableMap = {
    'دارو': 'Drugs',
    'دسته بندی': 'DrugCategories',
    'اشکال دارویی': 'DrugShapes',
  };
}

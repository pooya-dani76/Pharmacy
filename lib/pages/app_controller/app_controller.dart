import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/utils/hive_functions.dart';

class AppController extends GetxController {
  ThemeData themeData = themeColorCreator(appColor: Colors.purple);
  Color appColor = Colors.purple;
  List colors = [
    const Color(0xffc971ea),
    const Color(0xfff9b427),
    const Color(0xffef0a87),
    const Color(0xff9610fe),
    const Color(0xffff614e),
    const Color(0xfff63838),
    Colors.indigo,
    Colors.black,
  ];

  setThemeColor({required Color newAppColor}) async {
    themeData = themeColorCreator(appColor: newAppColor);
    appColor = newAppColor;
    await saveTheme(color: newAppColor);
    update();
  }
}

themeColorCreator({required Color appColor}) {
  ThemeData themeData = ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: appColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      buttonTheme: ButtonThemeData(buttonColor: appColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: appColor,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(10),
        isCollapsed: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ));
  return themeData;
}

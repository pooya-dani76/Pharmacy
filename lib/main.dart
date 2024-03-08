import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pharmacy/data_base/sqlit_storage.dart';
import 'package:pharmacy/pages/app_controller/app_controller.dart';
import 'package:pharmacy/routes/routes.dart';
import 'package:pharmacy/utils/hive_functions.dart';
import 'package:pharmacy/utils/utils.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await SqliteStorage.openDB();
  } catch (e) {
    Utils.logEvent(message: e.toString(), logType: LogType.error);
  }
  await Hive.initFlutter();
  AppController appController = Get.put(AppController());
  int colorValue = await restoreTheme();
  appController.setThemeColor(newAppColor: Color(colorValue));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (controller) {
        return GetMaterialApp(
          title: 'Pharmacy',
          debugShowCheckedModeBanner: false,
          theme: controller.themeData,
          getPages: Pages.pages,
          initialRoute: Routes.mainPage,
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: MediaQuery(
                data: mediaQueryData.copyWith(textScaler: const TextScaler.linear(1)),
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}

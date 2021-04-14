import 'package:copid_flutter/components/translations.dart';
import 'package:copid_flutter/constants.dart';
import 'package:copid_flutter/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  ThemeMode getThemeMode() {
    final box = GetStorage();
    String _themeMode = box.read("themeMode");

    if (_themeMode == "light") {
      FlutterStatusbarcolor.setNavigationBarColor(kPrimaryLightColor);
      return ThemeMode.light;
    } else if (_themeMode == "dark") {
      FlutterStatusbarcolor.setNavigationBarColor(kPrimaryDarkColor);
      return ThemeMode.dark;
    } else {
      Get.changeThemeMode(ThemeMode.system);
      box.write("themeMode", "same");
      FlutterStatusbarcolor.setNavigationBarColor(Colors.black);
      return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(411.42857142857144, 820.5714285714286),
      builder: () => GetMaterialApp(
        translations: AppTranslations(),
        supportedLocales: [Locale('id'), Locale('en')],
        title: 'Copid App',
        themeMode: getThemeMode(),
        defaultTransition: Transition.zoom,
        theme: klightTheme,
        darkTheme: kdarkTheme,
        home: MainScreen(),
      ),
    );
  }
}

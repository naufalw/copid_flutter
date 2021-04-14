import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:copid_flutter/components/font_size.dart';
import 'package:copid_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SidebarDrawer extends StatelessWidget {
  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      shrinkWrap: true,
      children: [
        Container(
          height: ScreenUtil().setHeight(150),
          color: Theme.of(context).accentColor,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Menu",
              style: TextStyle(
                  fontSize: FontSize.fontSize36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        ),
        ListTile(
          title: Text("Theme"),
          onTap: () {
            showConfirmationDialog(
              context: context,
              title: "Theme mode",
              initialSelectedActionKey: box.read("themeMode"),
              actions: [
                AlertDialogAction(label: "Dark", key: "dark"),
                AlertDialogAction(key: "light", label: "Light"),
                AlertDialogAction(key: "same", label: "Same as system")
              ],
            ).then((value) async {
              if (value == "light") {
                Get.changeThemeMode(ThemeMode.light);
                await FlutterStatusbarcolor.setNavigationBarColor(
                    kPrimaryLightColor);
              } else if (value == "dark") {
                Get.changeThemeMode(ThemeMode.dark);
                await FlutterStatusbarcolor.setNavigationBarColor(
                    kPrimaryDarkColor);
              } else if (value == "same") {
                Get.changeThemeMode(ThemeMode.system);
                await FlutterStatusbarcolor.setNavigationBarColor(Colors.black);
              }
              box.write("themeMode", value);
            });
          },
        ),
        ListTile(
          title: Text("Settings"),
        ),
        AboutListTile(
          applicationName: "Copid App",
          applicationVersion: "1.0.0+1",
          applicationIcon: FlutterLogo(),
          applicationLegalese:
              "Copyright 2021 Naufal Wiwit Putra\nThis app is licensed under GPLv3 License",
        ),
      ],
    ));
  }
}

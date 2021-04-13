import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:copid_flutter/components/font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          height: ScreenUtil().setHeight(140),
          color: Theme.of(context).accentColor,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Menu",
              style: TextStyle(
                  fontSize: FontSize.fontSize32, fontWeight: FontWeight.w700),
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
                AlertDialogAction(key: "light", label: "Light")
              ],
            ).then((value) {
              if (value == "light") {
                Get.changeThemeMode(ThemeMode.light);
              } else if (value == "dark") {
                Get.changeThemeMode(ThemeMode.dark);
              }
              box.write("themeMode", value);
            });
          },
        ),
        ListTile(
          title: Text("Settings"),
        )
      ],
    ));
  }
}

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:copid_flutter/backend/location.dart';
import 'package:copid_flutter/backend/rest_api.dart';
import 'package:copid_flutter/components/all_country.dart';
import 'package:copid_flutter/components/font_size.dart';
import 'package:copid_flutter/components/home_container_small.dart';
import 'package:copid_flutter/components/sidebar_drawer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:search_choices/search_choices.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  EasyRefreshController _controller = EasyRefreshController();
  var dio = Dio();
  DataCovid _datacovid = new DataCovid();
  final box = GetStorage();
  String countryName, countryID, temporaryCountryName, temporaryCountryIDSlug;
  Map covidData = {};
  bool loadingState = false;

  void getAllData() async {
    try {
      countryName = box.read('countryName') ?? 'Indonesia';
      countryID = box.read('countryID') ?? 'ID';
      covidData = await _datacovid.getData(countryID);
      print(covidData);
      if (covidData != null) {
        Get.showSnackbar(GetBar(
          title: "SUCCESS, country name : $countryName",
          duration: Duration(milliseconds: 1800),
          message: "Last update : ${covidData["latestDate"]}",
        ));
        setState(() {});
      }
    } catch (e) {
      Get.showSnackbar(GetBar(
        title: "ERROR",
        duration: Duration(milliseconds: 1800),
        message: e.toString(),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: SidebarDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: AutoSizeText(
          countryName,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.fontSize22,
              color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
        actions: [
          Tooltip(
            message: "Search location",
            child: Padding(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
              child: InkWell(
                  child: Icon(LineIcons.searchLocation),
                  onTap: () {
                    Get.defaultDialog(
                        actions: [
                          ButtonBar(
                            children: [
                              TextButton(
                                  child: Text("CANCEL"),
                                  onPressed: () => Get.back()),
                              TextButton(
                                child: Text("OK"),
                                onPressed: () async {
                                  Get.back();
                                  setState(() {
                                    loadingState = true;
                                  });
                                  try {
                                    Map newCovidData = await DataCovid()
                                        .getData(temporaryCountryIDSlug);
                                    if (newCovidData != null) {
                                      setState(() {
                                        loadingState = false;
                                      });
                                      _controller.finishRefresh(success: true);
                                      countryName = temporaryCountryName;
                                      Get.showSnackbar(GetBar(
                                        title:
                                            "SUCCESS!, country changed to : $countryName",
                                        duration: Duration(milliseconds: 1800),
                                        message:
                                            "Last update : ${newCovidData["latestDate"]}",
                                      ));
                                      box.write(
                                          'countryID', temporaryCountryIDSlug);
                                      box.write('countryName', countryName);
                                      setState(() {
                                        _controller.finishRefresh(
                                            success: true);
                                        covidData = newCovidData;
                                      });
                                    }
                                  } catch (e) {
                                    setState(() {
                                      loadingState = false;
                                    });
                                    Get.showSnackbar(GetBar(
                                      title: "ERROR",
                                      duration: Duration(milliseconds: 2000),
                                      message: e.toString(),
                                    ));
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                        radius: 0.0,
                        title: "Select Country",
                        backgroundColor: Theme.of(context).canvasColor,
                        content: Container(
                          color: Theme.of(context).canvasColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SearchChoices.single(
                                menuBackgroundColor:
                                    Theme.of(context).canvasColor,
                                items: allCountryList,
                                value: countryName,
                                hint: countryName,
                                isExpanded: true,
                                onChanged: (a) {
                                  setState(() {
                                    temporaryCountryIDSlug = a;
                                    temporaryCountryName =
                                        allCountryItem[countryIndex.indexOf(a)]
                                            ["Country"];
                                    print(temporaryCountryIDSlug);
                                    print(temporaryCountryName);
                                  });
                                },
                              ),
                            ],
                          ),
                        ));
                  }),
            ),
          ),
          Tooltip(
            message: "Use current location",
            child: Padding(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
              child: InkWell(
                child: Icon(
                  LineIcons.alternateMapMarker,
                ),
                onTap: () async {
                  _controller.callLoad();
                  setState(() {
                    loadingState = true;
                  });
                  try {
                    Map newCountryMap = await getCurrentCountry();
                    if (newCountryMap != null) {
                      String newCountryName = newCountryMap["name"];
                      String newCountryID = newCountryMap["id"];

                      Map newCovidData =
                          await DataCovid().getData(newCountryID);
                      if (newCovidData != null) {
                        setState(() {
                          loadingState = false;
                        });
                        _controller.finishRefresh(success: true);
                        Get.showSnackbar(GetBar(
                          title:
                              "SUCCESS!, country changed to : $newCountryName",
                          duration: Duration(milliseconds: 2000),
                          message:
                              "Last update : ${newCovidData["latestDate"]}",
                        ));
                        box.write('countryID', newCountryID);
                        box.write('countryName', newCountryName);
                        countryName = newCountryName;
                        setState(() {
                          covidData = newCovidData;
                        });
                      }
                    }
                  } catch (e) {
                    setState(() {
                      loadingState = false;
                    });
                    _controller.finishRefresh(success: false);
                    Get.showSnackbar(GetBar(
                      title: "ERROR",
                      duration: Duration(milliseconds: 2000),
                      message: e.toString(),
                    ));
                  }
                },
              ),
            ),
          )
        ],
      ),
      body: ModalProgressHUD(
        opacity: 0.6,
        color: Colors.black,
        inAsyncCall: loadingState,
        child: EasyRefresh(
          header: BezierCircleHeader(
              backgroundColor: Theme.of(context).accentColor),
          onRefresh: () async {
            bool result = await InternetConnectionChecker().hasConnection;
            if (result == true) {
              covidData = null;
              getAllData();
            } else {
              Get.showSnackbar(GetBar(
                title: "ERROR",
                duration: Duration(milliseconds: 1800),
                message: "Check your internet connection",
              ));
            }
          },
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeContainerSmall(
                    title: "Confirmed".tr,
                    value: covidData["latestConfirmed"] ?? null,
                    delta: covidData["deltaConfirmed"] ?? null,
                  ),
                  HomeContainerSmall(
                    title: "Active".tr,
                    value: covidData["latestActive"] ?? null,
                    delta: covidData["deltaActive"] ?? null,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeContainerSmall(
                    title: "Deaths".tr,
                    value: covidData["latestDeaths"] ?? null,
                    delta: covidData["deltaDeaths"] ?? null,
                  ),
                  HomeContainerSmall(
                    title: "Recovered".tr,
                    value: covidData["latestRecovered"] ?? null,
                    delta: covidData["deltaRecovered"] ?? null,
                  ),
                ],
              ),
              HomeContainerLarge(),
              HomeContainerLarge(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HomeContainerLarge extends StatelessWidget {
  const HomeContainerLarge({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(8.0),
        horizontal: ScreenUtil().setWidth(15.0),
      ),
      child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().setHeight(180),
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

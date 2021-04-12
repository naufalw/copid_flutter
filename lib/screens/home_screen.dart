import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:copid_flutter/backend/location.dart';
import 'package:copid_flutter/backend/rest_api.dart';
import 'package:copid_flutter/components/all_country.dart';
import 'package:copid_flutter/components/home_container_small.dart';
import 'package:customizable_space_bar/customizable_space_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:search_choices/search_choices.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  EasyRefreshController _controller = EasyRefreshController();
  var dio = Dio();
  DataCovid _datacovid = new DataCovid();
  final box = GetStorage();
  String countryName, countryID, temporaryCountryName, temporaryCountryIDSlug;
  Map covidData = {};

  void getAllData() async {
    try {
      countryName = box.read('countryName') ?? 'Indonesia';
      countryID = box.read('countryID') ?? 'ID';
      covidData = await _datacovid.getData(countryID);
      print(covidData);
      if (covidData != null) {
        Get.showSnackbar(GetBar(
          title: "SUCCESS, country name : $countryName",
          duration: Duration(milliseconds: 2500),
          message: "Last update : ${covidData["latestDate"]}",
        ));
        setState(() {});
      }
    } catch (e) {
      Get.showSnackbar(GetBar(
        title: "ERROR",
        duration: Duration(milliseconds: 2500),
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
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          countryName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Icon(LineIcons.mapPin),
        actions: [
          InkWell(
              child: Icon(LineIcons.searchLocation),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Theme.of(context).canvasColor,
                          content: Container(
                            color: Theme.of(context).canvasColor,
                            height: 135,
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
                                      temporaryCountryName = allCountryItem[
                                          countryIndex.indexOf(a)]["Country"];
                                      print(temporaryCountryIDSlug);
                                      print(temporaryCountryName);
                                    });
                                  },
                                ),
                                ButtonBar(
                                  children: [
                                    TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () => Get.back()),
                                    TextButton(
                                      child: Text("Ok"),
                                      onPressed: () async {
                                        Get.back();

                                        _controller.callRefresh();
                                        Map newCovidData = await DataCovid()
                                            .getData(temporaryCountryIDSlug);
                                        if (newCovidData != null) {
                                          _controller.finishRefresh(
                                              success: true);
                                          countryName = temporaryCountryName;
                                          Get.showSnackbar(GetBar(
                                            title:
                                                "SUCCESS!, country changed to : $countryName",
                                            duration:
                                                Duration(milliseconds: 2500),
                                            message:
                                                "Last update : ${newCovidData["latestDate"]}",
                                          ));
                                          box.write('countryID',
                                              temporaryCountryIDSlug);
                                          box.write('countryName', countryName);
                                          setState(() {
                                            _controller.finishRefresh(
                                                success: true);
                                            covidData = newCovidData;
                                          });
                                        }
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Icon(
                LineIcons.alternateMapMarker,
              ),
              onTap: () async {
                _controller.callRefresh();
                try {
                  Map country = await getCurrentCountry();
                  if (country != null) {
                    String newCountryName = country["name"];
                    String newCountryID = country["id"];

                    Map newCovidData = await DataCovid().getData(newCountryID);
                    if (newCovidData != null) {
                      _controller.finishRefresh(success: true);
                      Get.showSnackbar(GetBar(
                        title: "SUCCESS!, country changed to : $newCountryName",
                        duration: Duration(milliseconds: 2500),
                        message: "Last update : ${newCovidData["latestDate"]}",
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
                  _controller.finishRefresh(success: false);
                  Get.showSnackbar(GetBar(
                    title: "ERROR",
                    duration: Duration(milliseconds: 2500),
                    message: e.toString(),
                  ));
                }
              },
            ),
          )
        ],
      ),
      body: EasyRefresh(
        header:
            BezierCircleHeader(backgroundColor: Theme.of(context).accentColor),
        onRefresh: () async {
          bool result = await InternetConnectionChecker().hasConnection;
          if (result == true) {
            covidData = null;
            getAllData();
          } else {
            Get.showSnackbar(GetBar(
              title: "ERROR",
              duration: Duration(milliseconds: 2500),
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
                  title: "Confirmed",
                  value: covidData["latestConfirmed"],
                  delta: covidData["deltaConfirmed"],
                ),
                HomeContainerSmall(
                  title: "Active",
                  value: covidData["latestActive"],
                  delta: covidData["deltaActive"],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeContainerSmall(
                  title: "Deaths",
                  value: covidData["latestDeaths"],
                  delta: covidData["deltaDeaths"],
                ),
                HomeContainerSmall(
                  title: "Recovered",
                  value: covidData["latestRecovered"],
                  delta: covidData["deltaRecovered"],
                ),
              ],
            ),
            HomeContainerLarge(),
            HomeContainerLarge(),
          ],
        ),
      ),
    );
  }
}

class HomeContainerLarge extends StatelessWidget {
  const HomeContainerLarge({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: Container(
        width: 382,
        height: 180,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

class HomeContainerLargeLoading extends StatelessWidget {
  const HomeContainerLargeLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: Container(
        width: 382,
        height: 180,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(18)),
        child: Container(
          width: 350,
          height: 150,
          color: Colors.green,
        ),
      ),
    );
  }
}

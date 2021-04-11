import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:copid_flutter/backend/location.dart';
import 'package:copid_flutter/backend/rest_api.dart';
import 'package:customizable_space_bar/customizable_space_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:skeleton_text/skeleton_text.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  DataCovid _datacovid = new DataCovid();
  final box = GetStorage();
  String countryName;
  Map covidData = {};
  void getAllData() async {
    countryName = box.read('countryName') ?? 'Indonesia';
    covidData = await _datacovid.getData(countryName);
    print(covidData);
    if (covidData != null) {
      setState(() {});
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
    covidData = null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          leading: Icon(LineIcons.mapPin),
          actions: [
            GestureDetector(
              child: Icon(LineIcons.searchLocation),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Icon(
                  LineIcons.alternateMapMarker,
                ),
                onTap: () async {
                  try {
                    String country = await getCurrentCountry();
                    if (country != null) {
                      Map newCovidData = await DataCovid().getData(country);
                      if (newCovidData != null) {
                        Get.showSnackbar(GetBar(
                          title: "SUCCESS!, country changed to : $country",
                          duration: Duration(milliseconds: 3000),
                          message:
                              "Last update : ${newCovidData["latestDate"]}",
                        ));
                        box.write('countryName', country);
                        countryName = country;
                        setState(() {
                          covidData = newCovidData;
                        });
                      }
                    }
                  } catch (e) {
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
          flexibleSpace: CustomizableSpaceBar(
            builder: (context, scrollingRate) {
              return Padding(
                padding:
                    EdgeInsets.only(bottom: 13, left: 12 + 40 * scrollingRate),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    countryName,
                    style: TextStyle(
                        fontSize: 43 - 18 * scrollingRate,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
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
        )
      ],
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

class HomeContainerSmall extends StatelessWidget {
  const HomeContainerSmall({
    this.title,
    this.value,
    this.delta,
    Key key,
  }) : super(key: key);

  final title;
  final value;
  final delta;

  Widget getValueText() {
    if (value == null) {
      return SkeletonAnimation(
        shimmerColor: Colors.grey,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 45,
          width: 150,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(18)),
        ),
      );
    } else {
      return AutoSizeText(
        value,
        maxLines: 1,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 45),
      );
    }
  }

  Widget getDeltaText() {
    if (value == null) {
      return SkeletonAnimation(
        shimmerColor: Colors.grey,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 15,
          width: 80,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(18)),
        ),
      );
    } else {
      return AutoSizeText(
        delta,
        maxLines: 1,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 180,
        height: 122,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AutoSizeText(
                title,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.5),
              ),
              getValueText(),
              getDeltaText()
            ],
          ),
        ),
      ),
    );
  }
}

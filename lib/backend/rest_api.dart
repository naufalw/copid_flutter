import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class DataCovid {
  Future<Map> getData(countryName) async {
    var dio = Dio();
    DateTime fromDateDT = DateTime.now().subtract(Duration(days: 7));
    String fromDay = fromDateDT.day.toString();
    String fromMonth = fromDateDT.month.toString();
    String fromYear = fromDateDT.year.toString();
    String country = countryName;
    String urlAPI =
        "https://api.covid19api.com/live/country/$country/status/confirmed/date/$fromYear-$fromMonth-${fromDay}T00:00:00Z";
    var covidData = await dio.get(urlAPI);

    if (covidData.data[0]["Province"] == null) {
      Map latestData = covidData.data[covidData.data.length - 2];
      Map yesterdayData = covidData.data[covidData.data.length - 3];
      num latestConfirmed = latestData["Confirmed"];
      num latestDeaths = latestData["Deaths"];
      num latestRecovered = latestData["Recovered"];
      num latestActive = latestData["Active"];
      num deltaConfirmed = latestConfirmed - yesterdayData["Confirmed"];
      num deltaDeaths = latestDeaths - yesterdayData["Deaths"];
      num deltaRecovered = latestRecovered - yesterdayData["Recovered"];
      num deltaActive = latestActive - yesterdayData["Active"];
      String latestDate = latestData["Date"];
      Map covidDataMap = {
        "latestConfirmed":
            NumberFormat.decimalPattern('eu').format(latestConfirmed),
        "latestRecovered":
            NumberFormat.decimalPattern('eu').format(latestRecovered),
        "latestDeaths": NumberFormat.decimalPattern('eu').format(latestDeaths),
        "latestActive": NumberFormat.decimalPattern('eu').format(latestActive),
        "deltaConfirmed":
            NumberFormat.decimalPattern('eu').format(deltaConfirmed),
        "deltaRecovered":
            NumberFormat.decimalPattern('eu').format(deltaRecovered),
        "deltaDeaths": NumberFormat.decimalPattern('eu').format(deltaDeaths),
        "deltaActive": NumberFormat.decimalPattern('eu').format(deltaActive),
        "latestDate": latestDate
      };
      return covidDataMap;
    } else if (covidData.data[0]["Province"] != null) {
      List data = covidData.data;
      int confirmedSatuHari = 0,
          deathSatuHari = 0,
          activeSatuHari = 0,
          recoveredSatuHari = 0,
          index = 0;
      List country = [];
      String date;
      for (var i = 0; i < data.length; i++) {
        if (country.contains(data[i]["Province"]) == false) {
          country.add(data[i]["Province"]);
        }
      }
      List listDataCovid = [];
      int howManyCountry = country.length;
      double howManyDay = data.length / country.length;
      for (var i = 0; i < howManyDay; i++) {
        confirmedSatuHari = 0;
        deathSatuHari = 0;
        activeSatuHari = 0;
        recoveredSatuHari = 0;
        for (var i = 0; i < howManyCountry; i++) {
          confirmedSatuHari += data[index]["Confirmed"];
          activeSatuHari += data[index]["Active"];
          recoveredSatuHari += data[index]["Recovered"];
          deathSatuHari += data[index]["Deaths"];
          date = data[index]["Date"];
          index += 1;
        }

        listDataCovid.add({
          "Confirmed": confirmedSatuHari,
          "Recovered": recoveredSatuHari,
          "Deaths": deathSatuHari,
          "Active": activeSatuHari,
          "Date": date
        });
      }
      Map latestData = listDataCovid[listDataCovid.length - 2];
      Map yesterdayData = listDataCovid[listDataCovid.length - 3];
      num latestConfirmed = latestData["Confirmed"];
      num latestDeaths = latestData["Deaths"];
      num latestRecovered = latestData["Recovered"];
      num latestActive = latestData["Active"];
      num deltaConfirmed = latestConfirmed - yesterdayData["Confirmed"];
      num deltaDeaths = latestDeaths - yesterdayData["Deaths"];
      num deltaRecovered = latestRecovered - yesterdayData["Recovered"];
      num deltaActive = latestActive - yesterdayData["Active"];
      String latestDate = latestData["Date"];
      return {
        "latestConfirmed":
            NumberFormat.decimalPattern('eu').format(latestConfirmed),
        "latestRecovered":
            NumberFormat.decimalPattern('eu').format(latestRecovered),
        "latestDeaths": NumberFormat.decimalPattern('eu').format(latestDeaths),
        "latestActive": NumberFormat.decimalPattern('eu').format(latestActive),
        "deltaConfirmed":
            NumberFormat.decimalPattern('eu').format(deltaConfirmed),
        "deltaRecovered":
            NumberFormat.decimalPattern('eu').format(deltaRecovered),
        "deltaDeaths": NumberFormat.decimalPattern('eu').format(deltaDeaths),
        "deltaActive": NumberFormat.decimalPattern('eu').format(deltaActive),
        "latestDate": latestDate
      };
    } else {
      return {};
    }
  }
}

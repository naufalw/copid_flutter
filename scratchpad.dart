import "package:dio/dio.dart";

getData() async {
  var dio = Dio();
  var request = await dio.get(
      "https://api.covid19api.com/live/country/China/status/confirmed/date/2021-04-05T00:00:00Z");
  List data = request.data;
  // confirmedCaseProgress = [],
  // deathCaseProgress = [],
  // activeCaseProgress = [],
  // recoveredCaseProgress = [];
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
  print("Cino");
  print(listDataCovid);
}

main() {
  getData();
}

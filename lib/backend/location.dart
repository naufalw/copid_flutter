import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';

Future<Map<String, String>> getCurrentCountry() async {
  LocationPermission permission;
  var dio = Dio();
  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  Position position = await Geolocator.getCurrentPosition();

  GeoCode geoCode = GeoCode();
  Address currentHumanLocation = await geoCode.reverseGeocoding(
      latitude: position.latitude, longitude: position.longitude);

  String currentCountry = currentHumanLocation.countryCode;
  var countryRequests =
      await dio.get("https://restcountries.eu/rest/v2/alpha/$currentCountry");
  return {"name": countryRequests.data["name"], "id": currentCountry};
}

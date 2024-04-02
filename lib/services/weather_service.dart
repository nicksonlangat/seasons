import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seasons/models/weather.dart';

import "package:http/http.dart" as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  static String apiKey = "d6e02637ef131f658dd8e9243d783cb1";

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse("$BASE_URL?q=$cityName&appid=$apiKey&units=metric"));
    if (response.statusCode == 200) {
      // return response.body;
      return Weather.fromJson(
          jsonEncode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Error fetching weather");
    }
  }

  Future<String?> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placemarks[0].locality;
    print("here $city");
    return city;
  }
}

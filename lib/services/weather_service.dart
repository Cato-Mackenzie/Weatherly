import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:web_apllication_weatherly/models/weather_model.dart';

class WeatherService {
  // Base URL for the One Call API
  static const String oneCallBaseURL = 'https://api.openweathermap.org/data/3.0/onecall';

  final String apikey;

  WeatherService(this.apikey);

  // Get the current location of the phone
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Permissions are granted; we can access location
    return await Geolocator.getCurrentPosition(); // Removed desiredAccuracy
  }

  // Fetch weather data using the current location (latitude and longitude)
  Future<Weather> getWeatherFromLocation() async {
    // Get the current position (latitude and longitude)
    Position position = await getCurrentLocation();
    double latitude = position.latitude;
    double longitude = position.longitude;

    // Build the API URL using the latitude and longitude
    final String url = '$oneCallBaseURL?lat=$latitude&lon=$longitude&appid=$apikey&units=metric';

    // Send the GET request
    final response = await http.get(Uri.parse(url));

    // If the request was successful, parse the data and return the Weather object
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

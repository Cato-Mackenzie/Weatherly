import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:web_apllication_weatherly/services/weather_service.dart'; // Adjust the path as necessary
import 'package:web_apllication_weatherly/models/weather_model.dart'; // Adjust the path as necessary
import 'package:flutter/widgets.dart'; // Import the Flutter widgets package for the Icon class

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _weather; // Variable to hold weather data
  bool isLoading = true; // Flag to track loading state
  final String apiKey = 'YOUR API KEY  HERE'; // Replace with your actual API key
  late WeatherService weatherService; // Declare but don't initialize here

  @override
  void initState() {
    super.initState();
    weatherService = WeatherService(apiKey); // Initialize in initState
    fetchWeather(); // Fetch weather when the widget is initialized
  }

  Future<void> fetchWeather() async {
    try {
      _weather = await weatherService.getWeatherFromLocation();
    } catch (e) {
      // Handle errors here (e.g., show a message)
      print(e);
    } finally {
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

  String getWeatherAnimation(String? description) {
    // Check for null and return a default animation if necessary
    if (description == null || description.isEmpty) {
      return 'assets/sunny.json'; // Default animation for null or empty description
    }

    // Normalize the description to lowercase for easier comparison
    String desc = description.toLowerCase();

    // Mapping descriptions to animation asset names or paths
    if (desc.contains('clear')) {
      return 'assets/sunny.json'; // Clear sky
    } else if (desc.contains('cloud')) {
      return 'assets/cloudy.json'; // Cloudy
    } else if (desc.contains('rain')) {
      return 'assets/rainy.json'; // Rain
    } else if (desc.contains('drizzle')) {
      return 'assets/rainy.json'; // Drizzle
    } else if (desc.contains('thunderstorm')) {
      return 'assets/thunderstorms.json'; // Thunderstorm
    } else if (desc.contains('snow')) {
      return 'assets/snow.json'; // Snow
    } else if (desc.contains('mist') || desc.contains('fog')) {
      return 'assets/mist.json'; // Mist or fog
    } else if (desc.contains('haze')) {
      return 'assets/mist.json'; // Haze
    } else if (desc.contains('sand') || desc.contains('dust')) {
      return 'assets/sand.json'; // Sand or dust
    } else if (desc.contains('ash')) {
      return 'assets/mist.json'; // Ash
    } else if (desc.contains('squall')) {
      return 'assets/wind.json'; // Squall
    } else if (desc.contains('tornado')) {
      return 'assets/tornado.json'; // Tornado
    } else {
      return 'assets/sunny.json'; // Default animation for unrecognized descriptions
    }
  }

    String toSentenceCase(String text) {
    if (text.isEmpty) return text; // Handle empty string
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252525), // Set background color
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() // Show loading indicator
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // City Name with Location Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white, // Location icon color
                      ),
                      const SizedBox(width: 8), // Spacing between icon and text
                      Text(
                        _weather?.cityName ?? "Loading city...",
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white, // City name text color
                        ),
                      ),
                    ],
                  ),

                  // Animation 
                  Lottie.asset(
                    getWeatherAnimation(_weather?.description),
                    height: 400, // Set your desired height
                    width: 400,  // Set your desired width
                  ),

                  // Temperature
                  Text(
                    '${_weather?.temperature.round() ?? "Loading"}°C',
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white, // Temperature text color
                    ),
                  ),
                  // Description
                  Text(
                    toSentenceCase(_weather?.description ?? "Loading description..."),
                    style: const TextStyle(
                      fontSize: 24,
                      color: Color(0xFFFFE6A7), // Description text color
                    ),
                  ),
                  // Humidity
                  Text(
                    'Humidity: ${_weather?.humidity ?? "Loading"}%',
                    style: const TextStyle(
                      fontSize: 18,
                     color: Color(0xFFFFE6A7), // Humidity text color
                    ),
                  ),
                  // Feels Like
                  Text(
                    'Feels Like: ${_weather?.feelsLike.round() ?? "Loading"}°C',
                    style: const TextStyle(
                      fontSize: 18,
                     color: Color(0xFFFFE6A7), // Feels Like text color
                    ),
                  ),
                  // Wind Speed
                  Text(
                    'Wind Speed: ${_weather?.windSpeed ?? "Loading"} m/s',
                    style: const TextStyle(
                      fontSize: 18,
                     color: Color(0xFFFFE6A7), // Wind Speed text color
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double feelsLike;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final currentWeather = json['current'];
    return Weather(
      cityName: json['timezone'], // OpenWeatherMap does not return city name directly; you might need to use another API to get it
      temperature: currentWeather['temp'].toDouble(),
      description: currentWeather['weather'][0]['description'],
      feelsLike: currentWeather['feels_like'].toDouble(),
      humidity: currentWeather['humidity'],
      windSpeed: currentWeather['wind_speed'].toDouble(),
    );
  }
}

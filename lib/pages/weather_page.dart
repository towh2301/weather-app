import "dart:math";

import "package:flutter/material.dart";
import "package:weather_application_api/models/weather_model.dart";
import "package:weather_application_api/services/weather_service.dart";
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _mainCondition = '';
  String _asset = '';

  void getJsonCondition(String mainCondition) {
    _mainCondition = mainCondition;

    if (mainCondition == 'Clouds') {}
    switch (mainCondition) {
      case 'Clouds':
        _asset = 'assets/cloud.json';
      case 'Sunny':
        _asset = 'assets/sunny.json';
      case 'Rain':
        _asset = 'assets/rain.json';
      default:
        _asset = 'assets/night.json';
    }
  }

  // API key
  final _weatherService = WeatherService('8d06e0f8448b4f42f39e541017771bcd');
  WeatherModel? _weatherModel;
  // Fetch weather
  _fetchWeather() async {
    // Get current city
    String? cityName = await _weatherService.getCurrentCity();
    print(cityName);
    // Fetch weather for this city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weatherModel = weather;
      });
    } catch (e) {
      log(e.hashCode);
    }
  }

  // Weather animations
  //init state
  @override
  void initState() {
    super.initState();

    // Fetch weather on Start-up
    _fetchWeather();

    // Get json file condition
    getJsonCondition(_weatherModel?.mainCondition ?? 'Empty');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Set city name
            Text(_weatherModel?.cityName ?? "Loading City..."),
            // Load a Lottie file from your assets
            Lottie.asset(_asset),

            // Set temperature
            Text("${_weatherModel?.temperature.round()}°C"),

            // Set main condition
            Text(_mainCondition),
          ],
        ),
      ),
    );
  }
}

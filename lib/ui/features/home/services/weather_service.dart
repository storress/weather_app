import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/core/config/env.dart';
import 'package:weather_app/core/constants/endpoints.dart';
import 'package:weather_app/ui/features/home/dto/forecast_dto_model.dart';

class WeatherService {
  static const String baseUrl = ApiEndpoints.baseUrl;

  final String apiKey = Env.openWeatherApiKey; // Replace with your actual API key

  Future<ForecastDtoModel> getForecast(String city) async {
    if (apiKey.isEmpty) {
      throw Exception('OPENWEATHER_API_KEY not defined');
    }
    final url = ApiEndpoints.forecastByCityUri(city: city, apiKey: apiKey);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
        return ForecastDtoModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching forecast: $e');
    }
  }

  // Get weather by coordinates
  Future<Map<String, dynamic>> getWeatherByCoords(double lat, double lon) async {
    if (apiKey.isEmpty) {
      throw Exception('OPENWEATHER_API_KEY not defined');
    }
    final url = ApiEndpoints.weatherByCoordsUri(lat: lat, lon: lon, apiKey: apiKey);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:weather_app/core/config/env.dart';
import 'package:weather_app/ui/features/search/models/search_city_model.dart';
import 'package:weather_app/ui/features/home/services/weather_service.dart';
import 'package:weather_app/ui/features/home/dto/forecast_dto_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomeController {
  final WeatherService _weatherService = WeatherService();
  List<SearchCityModel> _allCities = [];
  final List<String> tabCities = ['Rio de Janeiro', 'Beijing', 'Los Angeles'];

  // Forecast data
  ForecastDtoModel? _forecastData;
  get forecastData => _forecastData;

  /// Load forecast data for a given city
  Future<void> loadForecast(String city) async {
    try {
      _forecastData = await _weatherService.getForecast(city);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading forecast: $e');
      }
    }
  }

  Future<List<SearchCityModel>> loadCities() async {
    if (_allCities.isNotEmpty) return _allCities;

    final raw = await rootBundle.loadString('assets/data/cities.min.json');
    final List data = json.decode(raw);
    _allCities = data.map((cityJson) => SearchCityModel.fromJson(Map<String, dynamic>.from(cityJson))).toList();

    return _allCities;
  }
}

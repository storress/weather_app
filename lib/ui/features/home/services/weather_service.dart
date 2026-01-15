// lib/data/services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/ui/features/home/dto/forecast_dto_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = 'fb7a15194674e4cc231ee9ba5df957f4'; // Replace with your actual API key

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    final url = Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  Future<ForecastDtoModel> getForecast(String city) async {
    final url = Uri.parse('$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);
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
    final url = Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}

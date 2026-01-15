import 'package:weather_app/ui/features/home/services/weather_service.dart';
import 'package:weather_app/ui/features/home/dto/forecast_dto_model.dart';

class HomeController {
  final WeatherService _weatherService = WeatherService();

  // Forecast data
  ForecastDtoModel? _forecastData;
  get forecastData => _forecastData;

  // Loading states
  bool _isLoadingForecast = false;
  get isLoadingForecast => _isLoadingForecast;

  // Error states
  String? _forecastError;
  get forecastError => _forecastError;

  /// Load forecast data for a given city
  Future<void> loadForecast(String city) async {
    _isLoadingForecast = true;
    _forecastError = null;
    try {
      _forecastData = await _weatherService.getForecast(city);
    } catch (e) {
      _forecastError = 'Error loading forecast: $e';
      print(_forecastError);
    } finally {
      _isLoadingForecast = false;
    }
  }

  /// Clear all data
  void clearData() {
    _forecastData = null;
    _forecastError = null;
  }
}

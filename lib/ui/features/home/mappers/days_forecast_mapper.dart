import 'package:weather_app/ui/features/home/dto/forecast_dto_model.dart';
import 'package:weather_app/ui/features/home/models/day_forecast_item_model.dart';

class DaysForecastMapper {
  DaysForecastMapper._();

  static List<DayForecastItemModel> map(ForecastDtoModel? forecastData, {int maxDays = 5}) {
    if (forecastData == null) return const [];

    final Map<DateTime, _DayAccumulator> daily = {};

    for (final forecastItem in forecastData.list) {
      final dateTime = DateTime.tryParse(forecastItem.dtTxt);
      if (dateTime == null) continue;

      final dayKey = DateTime(dateTime.year, dateTime.month, dateTime.day);

      final weather = forecastItem.weather.isNotEmpty ? forecastItem.weather.first : null;

      final bucket = daily.putIfAbsent(dayKey, () => _DayAccumulator(dayKey));

      bucket.add(
        minTemp: forecastItem.main.tempMin.toDouble(),
        maxTemp: forecastItem.main.tempMax.toDouble(),
        description: weather?.description ?? '',
        iconCode: weather?.icon ?? '',
      );
    }

    final sortedDays = daily.keys.toList()..sort();

    final result = <DayForecastItemModel>[];
    for (final day in sortedDays) {
      if (result.length >= maxDays) break;

      final dayAccumulator = daily[day]!;
      result.add(
        DayForecastItemModel(
          date: day,
          minTemperature: dayAccumulator.minTemp,
          maxTemperature: dayAccumulator.maxTemp,
          description: dayAccumulator.mostCommonDescription,
          iconCode: dayAccumulator.mostCommonIconCode,
        ),
      );
    }

    return result;
  }
}

class _DayAccumulator {
  _DayAccumulator(this.date) : minTemp = double.infinity, maxTemp = -double.infinity;

  final DateTime date;
  double minTemp;
  double maxTemp;

  final Map<String, int> _descriptions = {};
  final Map<String, int> _icons = {};

  void add({required double minTemp, required double maxTemp, required String description, required String iconCode}) {
    if (minTemp < this.minTemp) this.minTemp = minTemp;
    if (maxTemp > this.maxTemp) this.maxTemp = maxTemp;

    if (description.isNotEmpty) {
      _descriptions[description] = (_descriptions[description] ?? 0) + 1;
    }

    if (iconCode.isNotEmpty) {
      _icons[iconCode] = (_icons[iconCode] ?? 0) + 1;
    }
  }

  String get mostCommonDescription => _mostFrequent(_descriptions) ?? '';

  String get mostCommonIconCode => _mostFrequent(_icons) ?? '';

  String? _mostFrequent(Map<String, int> map) {
    if (map.isEmpty) return null;
    return map.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}

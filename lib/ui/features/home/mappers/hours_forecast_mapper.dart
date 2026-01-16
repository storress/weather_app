import 'package:weather_app/ui/features/home/dto/forecast_dto_model.dart';
import 'package:weather_app/ui/features/home/models/hour_forecast_item_model.dart';

class HoursForecastMapper {
  HoursForecastMapper._();

  /// Returns the next [maxItems] 3-hour slots (OpenWeather forecast list)
  static List<HourForecastItemModel> map(ForecastDtoModel? forecast, {int maxItems = 8}) {
    if (forecast == null) return const [];

    final result = <HourForecastItemModel>[];

    for (final item in forecast.list) {
      if (result.length >= maxItems) break;

      final dt = DateTime.tryParse(item.dtTxt);
      if (dt == null) continue;

      final weather = item.weather.isNotEmpty ? item.weather.first : null;

      result.add(
        HourForecastItemModel(
          dateTime: dt,
          temperature: item.main.temp.toDouble(),
          precipitationProbability: (item.pop).toDouble(),
          iconCode: weather?.icon ?? '',
          description: weather?.description ?? '',
        ),
      );
    }

    return result;
  }
}

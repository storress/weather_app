import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/endpoints.dart';
import 'package:weather_app/core/utils/date_formatters.dart';
import 'package:weather_app/ui/features/home/dto/forecast_dto_model.dart';
import 'package:weather_app/ui/features/home/mappers/days_forecast_mapper.dart';

class DaysForecastWidget extends StatelessWidget {
  const DaysForecastWidget({super.key, required this.forecastData});

  final ForecastDtoModel? forecastData;

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final displayData = DaysForecastMapper.map(forecastData);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: const Text('Next 5 days', style: TextStyle(fontSize: 20)),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
            margin: const EdgeInsets.only(bottom: 16),
          ),
          ...List.generate(displayData.length, (index) {
            final day = displayData[index];
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Image.network(
                        ApiEndpoints.weatherIconUrl(day.iconCode),
                        width: 48,
                        height: 48,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.cloud, color: Colors.orange, size: 32);
                        },
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              formatShortDay(day.date),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_capitalize(day.description)} throughout the day.',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${day.maxTemperature.toStringAsFixed(0)}° ${day.minTemperature.toStringAsFixed(0)}°',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (index < displayData.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(width: double.infinity, height: 1, color: Colors.grey[300]),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

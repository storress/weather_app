import 'package:flutter/material.dart';
import 'package:weather_app/ui/features/home/dto/forecast_dto_model.dart';

class HoursForecastWidget extends StatelessWidget {
  const HoursForecastWidget({super.key, required this.forecastData});

  final ForecastDtoModel? forecastData;

  List<Map<String, dynamic>> _processHourlyForecast() {
    if (forecastData == null) {
      return [];
    }
    final hourlyData = forecastData!.list.take(8).map((item) {
      final temp = item.main.temp;
      final time = item.dtTxt;
      final hour = time.split(' ')[1].substring(0, 5); // Extract HH:MM
      final pop = item.pop; // Probability of precipitation
      final iconCode = item.weather[0].icon; // Icon code from API

      return {
        'time': _formatTimeAmPm(hour),
        'temp': '${temp.toStringAsFixed(0)}°',
        'icon': iconCode,
        'pop': '${(pop * 100).toStringAsFixed(0)}%',
      };
    }).toList();

    return hourlyData;
  }

  String _formatTimeAmPm(String time) {
    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  String _getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  @override
  Widget build(BuildContext context) {
    final displayData = _processHourlyForecast();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: const Text('Next hours', style: TextStyle(fontSize: 20)),
          ),
          Container(width: double.infinity, height: 1, color: Colors.grey[300]),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: displayData.length,
              itemBuilder: (context, index) {
                final hour = displayData[index];
                return Row(
                  children: [
                    Container(
                      width: 80,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            hour['temp'] as String,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(hour['pop'] as String, style: const TextStyle(fontSize: 14, color: Colors.lightBlue)),
                          Image.network(
                            _getWeatherIconUrl(hour['icon'] as String),
                            width: 48,
                            height: 48,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.cloud, size: 32);
                            },
                          ),
                          Text(
                            hour['time'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    if (index < displayData.length - 1)
                      SizedBox(height: 50, child: VerticalDivider(color: Colors.grey[300], thickness: 1, width: 12)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

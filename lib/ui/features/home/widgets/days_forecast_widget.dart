import 'package:flutter/material.dart';
import 'package:weather_app/ui/features/home/dto/forecast_dto_model.dart';

class DaysForecastWidget extends StatelessWidget {
  const DaysForecastWidget({super.key, required this.forecastData});

  final ForecastDtoModel? forecastData;

  List<Map<String, dynamic>> _processForecastData() {
    if (forecastData == null) {
      return [];
    }
    final Map<String, Map<String, dynamic>> dailyMap = {};

    for (var item in forecastData!.list) {
      final dateTime = DateTime.parse(item.dtTxt);
      final dateKey =
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      final temp = item.main.temp;
      final tempMax = item.main.tempMax;
      final tempMin = item.main.tempMin;
      final condition = item.weather[0].main;
      final description = item.weather[0].description;
      final iconCode = item.weather[0].icon;

      if (!dailyMap.containsKey(dateKey)) {
        dailyMap[dateKey] = {
          'date': dateTime,
          'temps': [temp],
          'maxTemp': tempMax,
          'minTemp': tempMin,
          'condition': condition,
          'description': description,
          'iconCode': iconCode,
        };
      } else {
        dailyMap[dateKey]!['temps'].add(temp);
        dailyMap[dateKey]!['maxTemp'] = (dailyMap[dateKey]!['maxTemp'] as double) > tempMax
            ? dailyMap[dateKey]!['maxTemp']
            : tempMax;
        dailyMap[dateKey]!['minTemp'] = (dailyMap[dateKey]!['minTemp'] as double) < tempMin
            ? dailyMap[dateKey]!['minTemp']
            : tempMin;
      }
    }

    final dailyData = dailyMap.entries.take(5).map((entry) {
      final date = entry.value['date'] as DateTime;
      final maxTemp = entry.value['maxTemp'] as double;
      final minTemp = entry.value['minTemp'] as double;
      final condition = entry.value['condition'] as String;
      final description = entry.value['description'] as String;
      final iconCode = entry.value['iconCode'] as String;

      return {
        'dateFormatted': _formatDate(date),
        'high': '${maxTemp.toStringAsFixed(0)}°',
        'low': '${minTemp.toStringAsFixed(0)}°',
        'icon': iconCode,
        'description': _capitalize(description),
      };
    }).toList();

    return dailyData;
  }

  String _formatDate(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _getDayIcon(String iconCode) {
    // Ensure day icon by replacing night codes (n) with day codes (d)
    return iconCode.replaceAll(RegExp(r'n$'), 'd');
  }

  String _getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/${_getDayIcon(iconCode)}@2x.png';
  }

  @override
  Widget build(BuildContext context) {
    final displayData = _processForecastData();

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
                        _getWeatherIconUrl(day['icon'] as String),
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
                              day['dateFormatted'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${day['description'] as String} throughout the day.',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${day['high']} ${day['low']}',
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

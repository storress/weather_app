import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/endpoints.dart';
import 'package:weather_app/ui/features/home/controllers/home_controller.dart';
import 'package:weather_app/ui/features/home/widgets/forecast_tab_widget.dart';

class CityForecastSheet extends StatelessWidget {
  const CityForecastSheet({super.key, required this.cityName, required this.homeController});

  final String cityName;
  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: NetworkImage(ApiEndpoints.backgroundImageUrl), fit: BoxFit.cover),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cityName.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ForecastTabWidget(
              forecastData: homeController.forecastData,
              onRefresh: () => homeController.loadForecast(cityName),
            ),
          ),
        ],
      ),
    );
  }
}

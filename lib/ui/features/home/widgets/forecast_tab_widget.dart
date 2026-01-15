import 'package:flutter/material.dart';
import 'package:weather_app/ui/features/home/dto/forecast_dto_model.dart';
import 'package:weather_app/ui/features/home/widgets/days_forecast_widget.dart';
import 'package:weather_app/ui/features/home/widgets/hours_forecast_widget.dart';

class ForecastTabWidget extends StatelessWidget {
  final ForecastDtoModel? forecastData;
  final Future<void> Function() onRefresh;
  final ScrollController? scrollController;

  const ForecastTabWidget({super.key, required this.forecastData, required this.onRefresh, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          HoursForecastWidget(forecastData: forecastData),
          DaysForecastWidget(forecastData: forecastData),
        ],
      ),
    );
  }
}

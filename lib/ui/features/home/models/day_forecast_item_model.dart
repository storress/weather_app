class DayForecastItemModel {
  final DateTime date;
  final String description;
  final String iconCode;
  final double minTemperature;
  final double maxTemperature;

  const DayForecastItemModel({
    required this.date,
    required this.description,
    required this.iconCode,
    required this.minTemperature,
    required this.maxTemperature,
  });
}

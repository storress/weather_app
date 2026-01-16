class HourForecastItemModel {
  final DateTime dateTime;
  final double temperature;
  final double precipitationProbability;
  final String iconCode;
  final String description;

  const HourForecastItemModel({
    required this.dateTime,
    required this.temperature,
    required this.precipitationProbability,
    required this.iconCode,
    required this.description,
  });
}

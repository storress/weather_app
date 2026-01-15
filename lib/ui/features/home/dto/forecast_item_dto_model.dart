class ForecastItemDtoModel {
  final int dt;
  final TimestampWeatherDtoModel main;
  final List<GeneralWeatherDtoModel> weather;

  final int visibility;
  final double pop;
  final String dtTxt;

  ForecastItemDtoModel({
    required this.dt,
    required this.main,
    required this.weather,
    required this.visibility,
    required this.pop,
    required this.dtTxt,
  });

  factory ForecastItemDtoModel.fromJson(Map<String, dynamic> json) {
    return ForecastItemDtoModel(
      dt: json['dt'] as int? ?? 0,
      main: TimestampWeatherDtoModel.fromJson(json['main'] as Map<String, dynamic>? ?? {}),
      weather:
          (json['weather'] as List<dynamic>?)
              ?.map((item) => GeneralWeatherDtoModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      visibility: json['visibility'] as int? ?? 0,
      pop: (json['pop'] as num?)?.toDouble() ?? 0.0,
      dtTxt: json['dt_txt'] as String? ?? '',
    );
  }
}

class TimestampWeatherDtoModel {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int seaLevel;
  final int grndLevel;

  TimestampWeatherDtoModel({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
  });

  factory TimestampWeatherDtoModel.fromJson(Map<String, dynamic> json) {
    return TimestampWeatherDtoModel(
      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['feels_like'] as num?)?.toDouble() ?? 0.0,
      tempMin: (json['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (json['temp_max'] as num?)?.toDouble() ?? 0.0,
      pressure: json['pressure'] as int? ?? 0,
      humidity: json['humidity'] as int? ?? 0,
      seaLevel: json['sea_level'] as int? ?? 0,
      grndLevel: json['grnd_level'] as int? ?? 0,
    );
  }
}

class GeneralWeatherDtoModel {
  final int id;
  final String main;
  final String description;
  final String icon;

  GeneralWeatherDtoModel({required this.id, required this.main, required this.description, required this.icon});

  factory GeneralWeatherDtoModel.fromJson(Map<String, dynamic> json) {
    return GeneralWeatherDtoModel(
      id: json['id'] as int? ?? 0,
      main: json['main'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}

import 'package:weather_app/ui/features/home/dto/forecast_item_dto_model.dart';

class ForecastDtoModel {
  final String cod;
  final int message;
  final int cnt;
  final List<ForecastItemDtoModel> list;
  final City city;

  ForecastDtoModel({
    required this.cod,
    required this.message,
    required this.cnt,
    required this.list,
    required this.city,
  });

  factory ForecastDtoModel.fromJson(Map<String, dynamic> json) {
    return ForecastDtoModel(
      cod: json['cod'] as String? ?? '',
      message: json['message'] as int? ?? 0,
      cnt: json['cnt'] as int? ?? 0,
      list:
          (json['list'] as List<dynamic>?)
              ?.map((item) => ForecastItemDtoModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      city: City.fromJson(json['city'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class City {
  final int id;
  final String name;
  final Coord coord;
  final String country;
  final int population;
  final int timezone;
  final int sunrise;
  final int sunset;

  City({
    required this.id,
    required this.name,
    required this.coord,
    required this.country,
    required this.population,
    required this.timezone,
    required this.sunrise,
    required this.sunset,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      coord: Coord.fromJson(json['coord'] as Map<String, dynamic>? ?? {}),
      country: json['country'] as String? ?? '',
      population: json['population'] as int? ?? 0,
      timezone: json['timezone'] as int? ?? 0,
      sunrise: json['sunrise'] as int? ?? 0,
      sunset: json['sunset'] as int? ?? 0,
    );
  }
}

class Coord {
  final double lat;
  final double lon;

  Coord({required this.lat, required this.lon});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(lat: (json['lat'] as num?)?.toDouble() ?? 0.0, lon: (json['lon'] as num?)?.toDouble() ?? 0.0);
  }
}

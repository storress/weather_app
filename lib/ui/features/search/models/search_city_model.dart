class SearchCityModel {
  final int id;
  final String name;
  final String countryCode;
  final String countryName;
  final String stateCode;
  final double lat;
  final double lon;
  final String display;
  final String normalizedForSearchName;

  SearchCityModel({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.countryName,
    required this.stateCode,
    required this.lat,
    required this.lon,
    required this.display,
    required this.normalizedForSearchName,
  });

  factory SearchCityModel.fromJson(Map<String, dynamic> j) => SearchCityModel(
    id: j['id'],
    name: j['name'],
    countryCode: j['cc'],
    countryName: j['cf'],
    stateCode: j['sc'] ?? '',
    lat: (j['lat'] as num).toDouble(),
    lon: (j['lon'] as num).toDouble(),
    display: j['d'],
    normalizedForSearchName: j['s'],
  );
}

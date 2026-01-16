class ApiEndpoints {
  ApiEndpoints._();
  static const String baseUrl = 'api.openweathermap.org';
  static const String backgroundImageUrl = 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200';

  static Uri forecastByCityUri({required String city, required String apiKey, String units = 'metric'}) {
    return Uri.https(baseUrl, '/data/2.5/forecast', {'q': city, 'appid': apiKey, 'units': units});
  }

  static String weatherIconUrl(String iconCode, {bool forceDay = true}) {
    final code = forceDay ? iconCode.replaceFirst('n', 'd') : iconCode;
    return 'https://openweathermap.org/img/wn/$code@2x.png';
  }

  static Uri weatherByCoordsUri({
    required double lat,
    required double lon,
    required String apiKey,
    String units = 'metric',
  }) {
    return Uri.https(baseUrl, '/data/2.5/weather', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'appid': apiKey,
      'units': units,
    });
  }
}

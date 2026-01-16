import 'package:flutter/material.dart';
import 'package:weather_app/ui/features/search/models/search_city_model.dart';

class CitySearchDelegate extends SearchDelegate<SearchCityModel?> {
  CitySearchDelegate(this.cities);

  final List<SearchCityModel> cities;

  List<SearchCityModel> _filtered(String query) {
    if (query.isEmpty) return cities.take(50).toList();
    final q = query.toLowerCase();
    return cities.where((c) => c.normalizedForSearchName.contains(q)).take(50).toList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = _filtered(query);
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final city = results[index];
        return ListTile(
          leading: const Icon(Icons.location_city),
          title: Text(city.display),
          onTap: () => close(context, city),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _filtered(query);
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final city = results[index];
        return ListTile(
          leading: const Icon(Icons.location_city),
          title: Text(city.display),
          onTap: () => close(context, city),
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }
}

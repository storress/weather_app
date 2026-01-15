import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:weather_app/ui/features/home/controller/home_controller.dart';
import 'package:weather_app/ui/features/home/models/search_city_model.dart';
import 'package:weather_app/ui/features/home/widgets/forecast_tab_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final HomeController _homeController = HomeController();

  final List<String> _cities = ['Rio de Janeiro', 'Beijing', 'Los Angeles'];
  bool _isLoading = false;
  List<SearchCityModel> _allCities = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadForecast(_cities[0]);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      _loadForecast(_cities[_tabController.index]);
    }
  }

  Future<void> _loadForecast(String city) async {
    setState(() {
      _isLoading = true;
    });
    await _homeController.loadForecast(city);
    setState(() {
      _isLoading = false;
    });
  }

  Future<List<SearchCityModel>> _loadCities() async {
    if (_allCities.isNotEmpty) return _allCities;

    final raw = await rootBundle.loadString('assets/data/cities.min.json');
    final List<dynamic> data = json.decode(raw) as List<dynamic>;
    _allCities = data
        .whereType<Map<String, dynamic>>()
        .map((cityJson) => SearchCityModel.fromJson(cityJson))
        .toList()
        .cast<SearchCityModel>();
    return _allCities;
  }

  Future<void> _onSearchPressed() async {
    final cities = await _loadCities();
    if (!mounted) return;

    final selectedCity = await showSearch<SearchCityModel?>(context: context, delegate: _CitySearchDelegate(cities));

    if (selectedCity != null) {
      await _showCityForecastModal(selectedCity.name);
    }
  }

  Future<void> _showCityForecastModal(String cityName) async {
    setState(() {
      _isLoading = true;
    });
    await _homeController.loadForecast(cityName);
    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200'),
                  fit: BoxFit.cover,
                ),
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
                      forecastData: _homeController.forecastData,
                      onRefresh: () => _homeController.loadForecast(cityName),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getLastUpdated() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return 'Last updated on ${months[now.month - 1]} ${now.day} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Weather'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: _onSearchPressed)],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'RIO DE JANEIRO'),
                  Tab(text: 'BEIJING'),
                  Tab(text: 'LOS ANGELES'),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: _cities.map((_) {
                      return ForecastTabWidget(
                        forecastData: _homeController.forecastData,
                        onRefresh: () => _loadForecast(_cities[_tabController.index]),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: const BoxDecoration(color: Colors.blueAccent),
                alignment: Alignment.centerRight,
                child: Text(
                  _getLastUpdated(),
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _CitySearchDelegate extends SearchDelegate<SearchCityModel?> {
  _CitySearchDelegate(this.cities);

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

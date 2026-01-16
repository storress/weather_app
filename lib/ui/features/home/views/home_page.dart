import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/endpoints.dart';
import 'package:weather_app/ui/features/home/controllers/home_controller.dart';
import 'package:weather_app/ui/features/search/models/search_city_model.dart';
import 'package:weather_app/ui/features/search/widgets/city_forecast_sheet.dart';
import 'package:weather_app/ui/features/home/widgets/forecast_tab_widget.dart';
import 'package:weather_app/ui/features/home/widgets/last_updated_widget.dart';
import 'package:weather_app/ui/features/search/delegates/citiy_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final HomeController _homeController = HomeController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadForecast(_homeController.tabCities[0]);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      _loadForecast(_homeController.tabCities[_tabController.index]);
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

  Future<void> onSearchPressed() async {
    final cities = await _homeController.loadCities();
    if (!mounted) return;

    final selectedCity = await showSearch<SearchCityModel?>(context: context, delegate: CitySearchDelegate(cities));

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

    await showModalBottomSheet(
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
            return CityForecastSheet(cityName: cityName, homeController: _homeController);
          },
        );
      },
    );

    // Recargar la pestaña actual cuando se cierra el modal
    if (mounted) {
      await _loadForecast(_homeController.tabCities[_tabController.index]);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Weather'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () => onSearchPressed())],
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
                    image: DecorationImage(image: NetworkImage(ApiEndpoints.backgroundImageUrl), fit: BoxFit.cover),
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: _homeController.tabCities.map((_) {
                      return ForecastTabWidget(
                        forecastData: _homeController.forecastData,
                        onRefresh: () => _loadForecast(_homeController.tabCities[_tabController.index]),
                      );
                    }).toList(),
                  ),
                ),
              ),
              LastUpdatedWidget(),
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

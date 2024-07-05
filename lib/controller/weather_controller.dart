import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/weather_provider.dart';

class WeatherController {
  final WidgetRef ref;

  WeatherController(this.ref);

  Future<void> addCity(BuildContext context, String cityName) async {
    final success = await ref.read(citiesProvider.notifier).addCity(cityName);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add city: $cityName')),
      );
    }
  }

  void removeCity(String cityName) {
    ref.read(citiesProvider.notifier).removeCity(cityName);
  }

  void handleError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> refreshWeather(BuildContext context) async {
    final cities = ref.read(citiesProvider);
    if (cities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No cities to refresh')),
      );
      return;
    }

    for (var city in cities) {
      ref.refresh(weatherProvider(city));
    }
  }
}

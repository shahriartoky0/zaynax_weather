import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/weather.dart';
import '../services/weather_service.dart';

final weatherProvider = FutureProvider.family<Weather, String>((ref, cityName) async {
  final weatherService = WeatherService();
  return await weatherService.fetchWeather(cityName);
});

class CitiesNotifier extends StateNotifier<List<String>> {
  CitiesNotifier() : super(['New York', 'London', 'Tokyo', 'Sydney', 'Delhi']);

  Future<bool> addCity(String cityName) async {
    try {
      final weatherService = WeatherService();
      await weatherService.fetchWeather(cityName);
      state = [...state, cityName];
      return true;
    } catch (e) {
      return false;
    }
  }

  void removeCity(String cityName) {
    state = state.where((city) => city != cityName).toList();
  }
}

final citiesProvider = StateNotifierProvider<CitiesNotifier, List<String>>((ref) {
  return CitiesNotifier();
});

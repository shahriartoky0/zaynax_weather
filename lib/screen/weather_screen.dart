import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/weather_provider.dart';
import '../controller/weather_controller.dart';
import '../utilities/alert_dialouge.dart';
import 'add_city.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = ref.watch(citiesProvider);
    final controller = WeatherController(ref);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshWeather(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshWeather(context),
        child: cities.isEmpty
            ? const Center(
                child: Text('No cities available. Add a city to get started.'))
            : ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final cityName = cities[index];
                  final weatherAsyncValue =
                      ref.watch(weatherProvider(cityName));

                  return weatherAsyncValue.when(
                    data: (weather) {
                      final castedWeather = weather;
                      final displayName = castedWeather.cityName;
                      final displayTemp =
                          castedWeather.temperature.toStringAsFixed(1) ?? '--';
                      final displayCondition = castedWeather.weatherCondition;
                      final iconUrl = castedWeather.weatherIcon != null
                          ? 'https://openweathermap.org/img/wn/${castedWeather.weatherIcon}.png'
                          : '';

                      return ListTile(
                        title: Text(displayName),
                        subtitle: Text('$displayTemp °C - $displayCondition'),
                        leading: iconUrl.isNotEmpty
                            ? Image.network(iconUrl)
                            : const Icon(Icons.error),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => showDeleteConfirmationDialog(
                              context, cityName, controller),
                        ),
                      );
                    },
                    loading: () => ListTile(
                      title: Text(cityName),
                      subtitle: const Text('Loading...'),
                      leading: const CircularProgressIndicator(),
                    ),
                    error: (error, stack) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.handleError(context,
                            'Failed to load weather data for $cityName');
                      });
                      return ListTile(
                        title: Text(cityName),
                        subtitle: Text('Error: $error'),
                        leading: const Icon(Icons.error),
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final cityName = await showDialog<String>(
            context: context,
            builder: (context) => AddCityDialog(),
          );
          if (cityName != null && cityName.isNotEmpty) {
            await controller.addCity(context, cityName);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

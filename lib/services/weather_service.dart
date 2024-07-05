import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather.dart';


class WeatherService {
  static const String _OWapiKey = 'c5777fdd9ec008fa0b846a8bb7afd0c4';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse('$_baseUrl?q=$cityName&appid=$_OWapiKey'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}

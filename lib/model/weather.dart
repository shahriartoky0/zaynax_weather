class Weather {
  final String cityName;
  final double temperature;
  final String weatherCondition;
  final String weatherIcon;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.weatherCondition,
    required this.weatherIcon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'] - 273.15, // Convert from Kelvin to Celsius
      weatherCondition: json['weather'][0]['main'],
      weatherIcon: json['weather'][0]['icon'],
    );
  }
}

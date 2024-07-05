import 'package:flutter/material.dart';

import '../controller/weather_controller.dart';

void showDeleteConfirmationDialog(BuildContext context, String cityName, WeatherController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete City'),
        content: Text('Are you sure you want to delete $cityName?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.removeCity(cityName);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}
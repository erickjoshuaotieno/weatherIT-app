// homeCard2.dart
import 'package:flutter/material.dart';

class HomeCard2 extends StatelessWidget {
  final Map<String, dynamic>? currentWeather;
  final double? height;

  const HomeCard2({super.key, required this.currentWeather, this.height});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final humidity = currentWeather?['main']['humidity']?.toStringAsFixed(0) ?? 'N/A';
    final windSpeed = currentWeather?['wind']['speed']?.toStringAsFixed(1) ?? 'N/A';
    final pressure = currentWeather?['main']['pressure']?.toStringAsFixed(0) ?? 'N/A';

    return SizedBox(
      width: screenWidth * 0.95,
      height: height ?? 200,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left (Raindrop, Humidity, Label)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.water_drop_outlined, size: 30),
                  Text(
                    '$humidity%',
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const Text('Humidity'),
                ],
              ),
              // Center (Wind Icon, Speed, Label)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.air, size: 30),
                  Text(
                    '$windSpeed m/s',
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const Text('Wind'),
                ],
              ),
              // Right (Waves Icon, Pressure, Label)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.waves, size: 30),
                  Text(
                    '$pressure hPa',
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const Text('Pressure'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
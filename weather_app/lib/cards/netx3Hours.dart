// next3Hours.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/icons/iconMapping.dart';

class Next3HoursCard extends StatelessWidget {
  final int hourOffset; // 0 for next hour, 1 for hour after, 2 for two hours after
  final Map<String, dynamic>? forecastData;
  final double? cardHeight;

  const Next3HoursCard({
    super.key,
    required this.hourOffset,
    required this.forecastData,
    this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (forecastData == null) {
      return const SizedBox.shrink();
    }

    final DateTime currentDeviceTime = DateTime.now().toLocal();
    final DateTime nextHour = currentDeviceTime.add(Duration(hours: hourOffset + 1));
    final String nextHourFormatted = DateFormat('h:00 a').format(nextHour);

    final String condition = forecastData!['weather'][0]['description'] as String? ?? 'N/A';
    final String iconCode = forecastData!['weather'][0]['icon'] as String? ?? '';
    final String imagePath = IconMapping.getWeatherImage(iconCode);
    final double temperature = forecastData!['main']['temp'] as double? ?? 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: cardHeight ?? 80.0,
          maxHeight: cardHeight ?? 80.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Next Hour (based on device time) - THIS IS WHAT YOU ASKED FOR
              Text(
                nextHourFormatted,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              // Center: Condition and Image (from the forecastData - this is likely for 9 PM)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        condition,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Image.asset(
                      imagePath,
                      width: 98.5,
                      height: 98.5,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(width: 70, height: 70);
                      },
                    ),
                  ],
                ),
              ),
              // Right: Temperature (from the forecastData - also likely for 9 PM)
              Text(
                '${temperature.toStringAsFixed(0)}°C',
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
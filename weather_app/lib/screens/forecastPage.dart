import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/icons/iconMapping.dart'; // Ensure this file exists and provides getWeatherImage()

class ForecastPage extends StatelessWidget {
  final List<dynamic>? hourlyForecasts;

  const ForecastPage({super.key, this.hourlyForecasts});

  // Helper function to get the forecast for specific next days
  List<Map<String, dynamic>> _getNextSpecificDaysForecasts() {
    if (hourlyForecasts == null || hourlyForecasts!.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> specificDaysForecasts = [];
    DateTime today = DateTime.now().toLocal();
    Set<String> displayedDays = {DateFormat('yyyy-MM-dd').format(today)};
    List<String> targetDays = ['Friday', 'Saturday', 'Sunday', 'Monday', 'Tuesday']; // Added Tuesday

    for (final targetDay in targetDays) {
      for (final forecast in hourlyForecasts!) {
        DateTime forecastTime = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000).toLocal().toLocal();
        String forecastDate = DateFormat('yyyy-MM-dd').format(forecastTime);
        String forecastDayName = DateFormat('EEEE').format(forecastTime);

        if (forecastDayName == targetDay && !displayedDays.contains(forecastDate)) {
          specificDaysForecasts.add(forecast as Map<String, dynamic>);
          displayedDays.add(forecastDate);
          break; // Move to the next target day once found for the current target day
        }
      }
      if (specificDaysForecasts.length == 5) { // Updated the limit to 5
        break; // Stop if we have forecasts for all target days
      }
    }
    return specificDaysForecasts;
  }

  @override
  Widget build(BuildContext context) {
    final nextSpecificDaysForecasts = _getNextSpecificDaysForecasts();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Forecast',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildForecastSummaryCard(hourlyForecasts?.first, context),
              ),
            ),
            const SizedBox(height: 20),
            const Divider( // Added Divider here
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.grey,
            ),
            for (final forecast in nextSpecificDaysForecasts)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildNextDayForecastCard(forecast),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            // Add hourly forecast widgets here
          ],
        ),
      ),
    );
  }

  Widget _buildNextDayForecastCard(Map<String, dynamic> forecast) {
    final DateTime forecastTime = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000).toLocal().toLocal();
    final String day = DateFormat('EEEE').format(forecastTime);
    final String description = forecast['weather'][0]['description'] as String? ?? 'N/A';
    final String iconCode = forecast['weather'][0]['icon'] as String? ?? '';
    final String imagePath = IconMapping.getWeatherImage(iconCode);
    final double temperature = forecast['main']['temp'] as double? ?? 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Day and Description
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              description,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        const Spacer(), // Add space between left and right
        // Right: Image and Temperature
        Row(
          children: [
            Image.asset(
              imagePath,
              width: 100.0,
              height: 120.0,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(width: 60, height: 60);
              },
            ),
            const SizedBox(width: 16.0),
            Text(
              '${temperature.toStringAsFixed(0)}°C',
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForecastSummaryCard(Map<String, dynamic>? forecast, BuildContext context) {
    if (forecast == null) {
      return const Text('No forecast data available.');
    }

    final DateTime forecastDate = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000).toLocal();
    final String formattedDate = DateFormat('EEE, MMM d, h:mm a').format(forecastDate);
    final String condition = forecast['weather'][0]['description'] as String? ?? 'N/A';
    final String iconCode = forecast['weather'][0]['icon'] as String? ?? '';
    final String imagePath = IconMapping.getWeatherImage(iconCode);
    final double temperature = forecast['main']['temp'] as double? ?? 0.0;
    final int humidity = forecast['main']['humidity'] as int? ?? 0;
    final double windSpeed = forecast['wind']['speed'] as double? ?? 0.0;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.95,
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${temperature.toStringAsFixed(0)}°C',
                  style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Humidity: $humidity%',
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                Text(
                  'Wind: ${windSpeed.toStringAsFixed(1)} m/s',
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Right content: Centered text over image
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                condition.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4.0),
              SizedBox(
                height: 100,
                width: 120,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(width: 60, height: 60);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
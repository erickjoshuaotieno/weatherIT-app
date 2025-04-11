import 'package:flutter/material.dart';
import 'package:weather_app/icons/iconMapping.dart';

class HomeCard1 extends StatelessWidget {
  final Map<String, dynamic>? currentWeather;
  final double? height;

  const HomeCard1({super.key, required this.currentWeather, this.height});

  @override
  Widget build(BuildContext context) {
    final temperature = currentWeather?['main']['temp']?.toStringAsFixed(0) ?? 'N/A';
    final city = currentWeather?['name'] ?? 'N/A';
    final country = currentWeather?['sys']['country'] ?? 'N/A';
    final lat = currentWeather?['coord']['lat']?.toStringAsFixed(2) ?? 'N/A';
    final lon = currentWeather?['coord']['lon']?.toStringAsFixed(2) ?? 'N/A';
    final description = currentWeather?['weather'][0]['description'] as String? ?? 'N/A';
    final screenWidth = MediaQuery.of(context).size.width;
    final iconCode = currentWeather?['weather'][0]['icon'] as String? ?? '';
    final imagePath = IconMapping.getWeatherImage(iconCode);

    return SizedBox(
      width: screenWidth * 0.95,
      height: 200,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$temperature°C',
                    style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    city,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    country,
                    style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                  Text(
                    'Lat: $lat, Lon: $lon',
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
              Column( // Column for description and image
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    description.toUpperCase(),
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 0.0), // Spacing between description and image
                  SizedBox(
                    height: 120, // Adjusted height to accommodate description
                    width: 160,  // Adjusted width
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
        ),
      ),
    );
  }
}
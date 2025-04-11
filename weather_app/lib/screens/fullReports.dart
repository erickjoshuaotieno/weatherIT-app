import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FullReportsPage extends StatelessWidget {
  final Map<String, dynamic>? currentWeather;
  final String? next3HourForecast;
  final List<dynamic>? dailyForecasts; // Retaining as dynamic to match potential API structure

  const FullReportsPage({
    super.key,
    this.currentWeather,
    this.next3HourForecast,
    this.dailyForecasts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Full Weather Report')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center( // Wrapped the Text widget with Center
              child: Text(
                'Current Weather',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            if (currentWeather != null)
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(150), // Adjust width as needed
                  1: FlexColumnWidth(),
                },
                border: TableBorder.all(color: Colors.grey.shade300),
                children: [
                  _buildTableRow('Description', currentWeather?['weather'][0]['description'] ?? 'N/A'),
                  _buildTableRow('Temperature', '${currentWeather?['main']['temp']?.toStringAsFixed(1) ?? 'N/A'} °C'),
                  _buildTableRow('Feels Like', '${currentWeather?['main']['feels_like']?.toStringAsFixed(1) ?? 'N/A'} °C'),
                  _buildTableRow('Temperature Min', '${currentWeather?['main']['temp_min']?.toStringAsFixed(1) ?? 'N/A'} °C'),
                  _buildTableRow('Temperature Max', '${currentWeather?['main']['temp_max']?.toStringAsFixed(1) ?? 'N/A'} °C'),
                  _buildTableRow('Humidity', '${currentWeather?['main']['humidity'] ?? 'N/A'} %'),
                  _buildTableRow('Pressure', '${currentWeather?['main']['pressure'] ?? 'N/A'} hPa'),
                  _buildTableRow('Wind Speed', '${currentWeather?['wind']['speed']?.toStringAsFixed(1) ?? 'N/A'} m/s'),
                  _buildTableRow('Wind Direction', '${currentWeather?['wind']['deg'] ?? 'N/A'} °'),
                  _buildTableRow('Cloudiness', '${currentWeather?['clouds']['all'] ?? 'N/A'} %'),
                  _buildTableRow('City', currentWeather?['name'] ?? 'N/A'),
                  _buildTableRow('Country', currentWeather?['sys']['country'] ?? 'N/A'),
                  if (currentWeather?['sys']['sunrise'] != null)
                    _buildTableRow(
                        'Sunrise',
                        DateFormat('yyyy-MM-dd HH:mm:ss Z')
                            .format(DateTime.fromMillisecondsSinceEpoch(currentWeather!['sys']['sunrise'] * 1000).toLocal())),
                  if (currentWeather?['sys']['sunset'] != null)
                    _buildTableRow(
                        'Sunset',
                        DateFormat('yyyy-MM-dd HH:mm:ss Z')
                            .format(DateTime.fromMillisecondsSinceEpoch(currentWeather!['sys']['sunset'] * 1000).toLocal())),
                ],
              )
            else
              const Text('No current weather data available.'),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String name, String data) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data),
        ),
      ],
    );
  }
}
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String _apiKey = 'ce43c3377f8a746c2423a90de43503a9';

  Future<Map<String, dynamic>> getCurrentWeather25(double latitude, double longitude) async {
    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        print('API 2.5 Current Weather Failed: ${response.statusCode}, ${response.body}');
        return {'success': false, 'error': 'Failed to fetch current weather (API 2.5)'};
      }
    } catch (e) {
      print('API 2.5 Current Weather Error: $e');
      return {'success': false, 'error': 'Could not connect for current weather (API 2.5)'};
    }
  }

  Future<Map<String, dynamic>> get5Day3HourForecast(double latitude, double longitude) async {
    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        print('5 Day/3 Hour Forecast API Failed: ${response.statusCode}, ${response.body}');
        return {'success': false, 'error': 'Failed to fetch 5-day/3-hour forecast'};
      }
    } catch (e) {
      print('5 Day/3 Hour Forecast API Error: $e');
      return {'success': false, 'error': 'Could not connect for 5-day/3-hour forecast'};
    }
  }

  Future<Position?> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        return null;
      }
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
        return position;
      } catch (e) {
        print('Error getting location: $e');
        return null;
      }
    } else {
      print('Location permissions were denied.');
      return null;
    }
  }
}
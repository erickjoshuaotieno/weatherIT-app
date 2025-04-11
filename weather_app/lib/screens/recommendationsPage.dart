import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class RecommendationsPage extends StatefulWidget {
  final Map<String, dynamic>? currentWeather;
  final List<dynamic>? next3HourForecast;

  const RecommendationsPage({super.key, this.currentWeather, this.next3HourForecast});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  String recommendations = 'Fetching recommendations...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    setState(() {
      _isLoading = true;
      recommendations = 'Fetching recommendations...';
    });

    if (widget.currentWeather == null) {
      setState(() {
        recommendations = 'No current weather data available for recommendations.';
        _isLoading = false;
      });
      return;
    }

    final apiKey = 'AIzaSyBRp848rmMGd3zErs5x6-e7Jzu18JIvZn0';
    final prompt = _buildGeminiPrompt(widget.currentWeather, widget.next3HourForecast);
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {'parts': [{'text': prompt}]}],
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['candidates'] != null && jsonResponse['candidates'].isNotEmpty &&
            jsonResponse['candidates'][0]['content'] != null &&
            jsonResponse['candidates'][0]['content']['parts'] != null &&
            jsonResponse['candidates'][0]['content']['parts'].isNotEmpty) {
          String generatedText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
          // Filter out asterisks from the response
          generatedText = generatedText.replaceAll('*', '');
          setState(() {
            recommendations = generatedText;
            _isLoading = false;
          });
        } else {
          print('Gemini API Response Error: Incomplete response structure');
          setState(() {
            recommendations = 'Failed to fetch recommendations: Incomplete response.';
            _isLoading = false;
          });
        }
      } else {
        print('Gemini API Error: ${response.statusCode} - ${response.body}');
        setState(() {
          recommendations = 'Failed to fetch recommendations.';
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error calling Gemini API: $error');
      setState(() {
        recommendations = 'Error fetching recommendations.';
        _isLoading = false;
      });
    }
  }

  String _buildGeminiPrompt(Map<String, dynamic>? currentWeather, List<dynamic>? next3HourForecast) {
    String prompt = 'Based on the current weather  (current time is ${DateFormat('EEEE, MMMM d, h:mm a', 'en_US').format(DateTime.now().toLocal())}):\n\n';

    if (currentWeather != null) {
      prompt += 'Current conditions:\n';
      prompt += '- Description: ${currentWeather['weather'][0]['description'] ?? 'N/A'}\n';
      prompt += '- Temperature: ${currentWeather['main']['temp']?.toStringAsFixed(1) ?? 'N/A'} °C\n';
      prompt += '- Feels Like: ${currentWeather['main']['feels_like']?.toStringAsFixed(1) ?? 'N/A'} °C\n';
      prompt += '- Humidity: ${currentWeather['main']['humidity'] ?? 'N/A'} %\n';
      prompt += '- Wind Speed: ${currentWeather['wind']['speed']?.toStringAsFixed(1) ?? 'N/A'} m/s\n';
    } else {
      prompt += 'No current weather data.\n';
    }

    if (next3HourForecast != null && next3HourForecast.isNotEmpty) {
      prompt += '\nWeather forecast for the next 3 hours (approximately):\n';
      // Assuming the first item in the list is representative for the next 3 hours
      final nextForecast = next3HourForecast[0];
      prompt += '- Description: ${nextForecast['weather'][0]['description'] ?? 'N/A'}\n';
      prompt += '- Temperature: ${nextForecast['main']['temp']?.toStringAsFixed(1) ?? 'N/A'} °C\n';
      prompt += '- Chance of Rain: ${(nextForecast['pop'] ?? 0).toStringAsFixed(2)}\n';
    } else {
      prompt += '\nNo specific forecast for the next 3 hours available.\n';
    }

    prompt += '\nConsidering these conditions and the near-term forecast, please provide relevant recommendations , including:\n';
    prompt += '- Appropriate dressing code.\n';
    prompt += '- Whether it\'s a good time to go out and enjoy outdoor activities.\n';
    prompt += '- Any other relevant advice or things to be aware of based on the weather.';

    return prompt;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Recommendations'),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: screenWidth * 0.95,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    const SizedBox(height: 16.0),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            recommendations,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
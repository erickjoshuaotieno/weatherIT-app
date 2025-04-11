import 'package:flutter/material.dart';
import 'package:weather_app/cards/homeCard1.dart';
import 'package:weather_app/cards/homeCard2.dart';
import 'package:weather_app/cards/netx3Hours.dart';
import 'package:weather_app/weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/screens/forecastPage.dart';
import 'package:weather_app/screens/fullReports.dart';
import 'package:weather_app/screens/recommendationsPage.dart';
import 'package:weather_app/screens/login.dart'; // Import LoginPage

class EnergyHomePage extends StatefulWidget {
  final String loggedInUsername; // Receive the username
  const EnergyHomePage({super.key, required this.loggedInUsername});

  @override
  State<EnergyHomePage> createState() => _EnergyHomePageState();
}

class _EnergyHomePageState extends State<EnergyHomePage> {
  bool isDarkMode = true;
  Map<String, dynamic>? _currentWeatherData;
  List<dynamic>? _hourlyForecastData;
  List<String>? _dailyForecasts;
  String? _errorMessage;
  bool _isLoading = true;
  final _weatherService = WeatherService();
  int _selectedIndex = 0;
  final double _next3HoursCardHeight = 100.0;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF2E2E3A) : Colors.white,
          title: Text(
            'Log Out',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.lightBlueAccent,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                // Navigate to the login page (assuming it's your homepage)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
                // Optionally, you might want to clear any user session data here
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherDataOnStartup();
  }

  Future<void> _fetchWeatherDataOnStartup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentWeatherData = null;
      _hourlyForecastData = null;
      _dailyForecasts = null;
    });

    final position = await _weatherService.getCurrentLocation();
    if (position != null) {
      await _fetchWeatherData(position.latitude, position.longitude);
    } else {
      setState(() {
        _errorMessage = 'Location permission not granted.';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    final currentWeatherResult = await _weatherService.getCurrentWeather25(latitude, longitude);
    final forecastResult = await _weatherService.get5Day3HourForecast(latitude, longitude);

    if (currentWeatherResult['success'] == true && forecastResult['success'] == true) {
      final forecastList = (forecastResult['data'] as Map<String, dynamic>)['list'] as List<dynamic>?;
      List<String> dailyData = [];
      if (forecastList != null && forecastList.isNotEmpty) {
        DateTime currentDate = DateTime.now().toLocal().subtract(Duration(
          hours: DateTime.now().toLocal().hour,
          minutes: DateTime.now().toLocal().minute,
          seconds: DateTime.now().toLocal().second,
          milliseconds: DateTime.now().toLocal().millisecond,
        ));
        Set<String> displayedDates = {};
        for (var forecast in forecastList) {
          final DateTime forecastDate = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000).toLocal();
          final String formattedDate = DateFormat('EEE, MMM d').format(forecastDate);
          if (forecastDate.isAfter(currentDate) && !displayedDates.contains(formattedDate)) {
            dailyData.add('$formattedDate: ${forecast['weather'][0]['description']}, Temp: ${forecast['main']['temp']} °C');
            displayedDates.add(formattedDate);
            if (displayedDates.length == 5) {
              break;
            }
          }
        }
      }

      setState(() {
        _currentWeatherData = currentWeatherResult['data'] as Map<String, dynamic>;
        _hourlyForecastData = forecastList;
        _dailyForecasts = dailyData;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = (currentWeatherResult['error'] ?? '') +
            (forecastResult['error'] != null ? '\n' + forecastResult['error'] : '');
        _isLoading = false;
      });
    }
  }

  Widget _getBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }

    switch (_selectedIndex) {
      case 0:
        final now = DateTime.now();
        final formattedDate = DateFormat('EEE, MMM d, ' 'h:mm a').format(now);

        List<Widget> nextThreeHourCards = [];
        final currentDeviceHour = DateTime.now().toLocal();

        if (_hourlyForecastData != null && _hourlyForecastData!.isNotEmpty) {
          for (int i = 0; i < 3; i++) {
            final targetTime = currentDeviceHour.add(Duration(hours: i + 1));
            Map<String, dynamic>? closestForecast;
            Duration closestDifference = const Duration(days: 365);

            for (var forecast in _hourlyForecastData!) {
              final forecastTime = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000).toLocal();
              final difference = forecastTime.difference(targetTime).abs();

              if (difference < closestDifference) {
                closestDifference = difference;
                closestForecast = forecast as Map<String, dynamic>;
              }
            }

            nextThreeHourCards.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Next3HoursCard(
                  hourOffset: i,
                  forecastData: closestForecast,
                  cardHeight: _next3HoursCardHeight,
                ),
              ),
            );

            if (i < 2) {
              nextThreeHourCards.add(const SizedBox(height: 8.0));
            }
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Text(
                  widget.loggedInUsername, // Use the received username
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: HomeCard1(currentWeather: _currentWeatherData),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Current Conditions',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: HomeCard2(currentWeather: _currentWeatherData),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: Colors.grey,
                  thickness: 0.8,
                ),
              ),
              const SizedBox(height: 20),
              ...nextThreeHourCards,
              const SizedBox(height: 20),
              // Removed the Slider and its label
            ],
          ),
        );

      case 1:
        return ForecastPage(hourlyForecasts: _hourlyForecastData);
      case 2:
        return FullReportsPage(
          currentWeather: _currentWeatherData,
          next3HourForecast: _hourlyForecastData != null && _hourlyForecastData!.length > 1
              ? 'Next 3-Hour Forecast (${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(_hourlyForecastData![1]['dt'] * 1000).toLocal())}):\nDescription: ${_hourlyForecastData![1]['weather'][0]['description']}\nTemperature: ${_hourlyForecastData![1]['main']['temp']} °C'
              : 'No next 3-hour forecast available.',
          dailyForecasts: _dailyForecasts,
        );
      case 3:
        return RecommendationsPage(
          currentWeather: _currentWeatherData, // Pass the current weather data
          next3HourForecast: _hourlyForecastData?.take(3).toList(), // Pass the next 3 hours of forecast data
        );
      default:
        return const Center(child: Text('Something went wrong.'));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 4,
            title: GestureDetector(
              onTap: () {
                _showLogoutDialog(context);
              },
              child: Image.asset(
                'assets/images/ic_launcher.png',
                height: 30,
              ),
            ),
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: toggleTheme,
                  icon: Icon(
                    isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  ),
                  tooltip: 'Toggle Theme',
                ),
              ),
            ],
          ),
          body: _getBody(),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud_outlined),
                label: 'Forecast',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.content_copy),
                label: 'Reports',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.android),
                label: 'Recommendations',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
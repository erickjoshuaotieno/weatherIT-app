# WeatherIT App

A simple and intuitive weather application built with Flutter. Get real-time weather updates, hourly forecasts, and more!

## Features

* **Current Weather:** Displays the current temperature, conditions, humidity, wind speed, and more for your location.
* **Hourly Forecast:** Provides a detailed weather forecast for the next few hours.
* **5-Day Forecast:** Shows a summary of the weather conditions for the upcoming five days.
* **Location Services:** Automatically fetches your current location for accurate weather data.
* **Dark/Light Mode:** Offers a toggleable dark and light theme for user preference.
* **Recommendations:** Provides basic recommendations based on the current weather conditions.
* **Full Reports:** Detailed view of various weather parameters.

## Technologies Used

* Flutter
* Dart
* OpenWeatherMap API (or your chosen weather API)
* `dio` (for HTTP requests)
* `intl` (for date and time formatting)
* `geolocator` (for location services)
* Firebase (for user authentication - if implemented)

## Getting Started

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    ```

2.  **Navigate to the project directory:**
    ```bash
    cd weatherIT
    ```

3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Set up your Weather API key:**
    * Sign up for an account at [OpenWeatherMap](https://openweathermap.org/) (or your chosen weather API provider).
    * Obtain your API key.
    * Replace the placeholder API key in your `lib/weather/weather_service.dart` file (or wherever you've implemented the API call).

5.  **(Optional) Set up Firebase:**
    * If your app uses Firebase for authentication, create a Firebase project.
    * Follow the FlutterFire documentation to add Firebase to your Flutter project: [https://firebase.google.com/docs/flutter/setup](https://firebase.google.com/docs/flutter/setup)
    * Place your `google-services.json` (for Android) and `Runner-Info.plist` (for iOS) files in the appropriate directories.

6.  **Run the app:**
    ```bash
    flutter run
    ```

## Building the APK (Release Version)

```bash
flutter build apk --release

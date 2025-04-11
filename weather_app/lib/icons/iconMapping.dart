
class IconMapping {
  static String getWeatherImage(String iconCode) {
    switch (iconCode) {
      case '01d': // clear sky day
        return 'assets/images/clear_day.png';
      case '01n': // clear sky night
        return 'assets/images/clear_night.png';
      case '02d': // few clouds day
      case '02n': // few clouds night
        return 'assets/images/few_clouds.png';
      case '03d': // scattered clouds day
      case '03n': // scattered clouds night
      case '04d': // broken clouds day
      case '04n': // broken clouds night
        return 'assets/images/scattered_clouds.png';
      case '09d': // shower rain day
      case '09n': // shower rain night
      case '10d': // rain day
      case '10n': // rain night
        return 'assets/images/rain.png'; // Grouping light rain with regular rain for image
      case '11d': // thunderstorm day
      case '11n': // thunderstorm night
        return 'assets/images/thunderstorm.png';
      case '13d': // snow day (less common in Kenya)
      case '13n': // snow night (very rare in most of Kenya)
        return 'assets/images/scattered_clouds.png'; // Using scattered clouds as a fallback
      case '50d': // mist day
      case '50n': // mist night
        return 'assets/images/mist.png';
      case '08d': // overcast clouds day
      case '08n': // overcast clouds night
        return 'assets/images/overcast_clouds.png';
      default:
        return 'assets/images/clear_day.png'; // Default to clear day
    }
  }

  static String getWeatherDescription(String description) {
    String lowerDescription = description.toLowerCase();
    if (lowerDescription.contains('clear sky')) {
      return 'Clear';
    } else if (lowerDescription.contains('few clouds')) {
      return 'Few Clouds';
    } else if (lowerDescription.contains('scattered clouds') || lowerDescription.contains('broken clouds') || lowerDescription.contains('overcast clouds')) {
      return 'Cloudy';
    } else if (lowerDescription.contains('shower rain') || lowerDescription.contains('drizzle')) {
      return 'Showers';
    } else if (lowerDescription.contains('rain')|| lowerDescription.contains('light rain')) {
      return 'Rain'; // Grouping light rain with regular rain for description
    } else if (lowerDescription.contains('thunderstorm')) {
      return 'Thunderstorm';
    } else if (lowerDescription.contains('mist') || lowerDescription.contains('fog')) {
      return 'Mist';
    } else {
      return lowerDescription.split(' ').first.toUpperCase() + lowerDescription.substring(1); // Basic capitalization
    }
  }
}
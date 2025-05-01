import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static final String _apiKey = dotenv.get('OPENWEATHERMAP_API_KEY');
  static const String _baseUrl = 'https://pro.openweathermap.org/data/2.5';

  // Add headers to mimic browser request
  final Map<String, String> _headers = {
    'Accept': 'application/json',
    'User-Agent': 'Mozilla/5.0',
  };

  Future<Position> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Location error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _makeApiRequest(Uri uri) async {
    try {
      print('Making request to: ${uri.toString()}');
      final response = await http.get(uri, headers: _headers);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception(
            'API key is invalid or not activated. Please check your OpenWeatherMap API key and wait up to 2 hours after registration for activation.');
      } else if (response.statusCode == 429) {
        throw Exception('API call limit exceeded. Please try again later.');
      } else {
        final errorData = json.decode(response.body);
        print('Error data: $errorData');
        throw Exception(errorData['message'] ??
            'Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('API request error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      // Get current position
      Position position = await _getCurrentLocation();
      print('Got position: ${position.latitude}, ${position.longitude}');

      // Fetch weather data
      final uri = Uri.parse('$_baseUrl/weather').replace(
        queryParameters: {
          'lat': position.latitude.toString(),
          'lon': position.longitude.toString(),
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      return await _makeApiRequest(uri);
    } catch (e) {
      print('Weather error: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error getting weather data: $e');
    }
  }

  Future<Map<String, dynamic>> getDetailedWeather() async {
    try {
      Position position = await _getCurrentLocation();
      print(
          'Got position for detailed weather: ${position.latitude}, ${position.longitude}');

      // Get current weather
      final currentUri = Uri.parse('$_baseUrl/weather').replace(
        queryParameters: {
          'lat': position.latitude.toString(),
          'lon': position.longitude.toString(),
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      // Get 5-day forecast
      final forecastUri = Uri.parse('$_baseUrl/forecast').replace(
        queryParameters: {
          'lat': position.latitude.toString(),
          'lon': position.longitude.toString(),
          'appid': _apiKey,
          'units': 'metric',
        },
      );

      final currentData = await _makeApiRequest(currentUri);
      final forecastData = await _makeApiRequest(forecastUri);

      // Process the forecast data to get hourly and daily data
      final List<dynamic> hourlyData = [];
      final List<dynamic> dailyData = [];
      final Map<String, dynamic> processedDailyData = {};

      // Process each forecast item
      for (var item in forecastData['list']) {
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        final String dateKey = '${date.year}-${date.month}-${date.day}';

        // Add to hourly data
        hourlyData.add(item);

        // Process daily data
        if (!processedDailyData.containsKey(dateKey)) {
          processedDailyData[dateKey] = {
            'dt': item['dt'],
            'temp': {
              'min': item['main']['temp'],
              'max': item['main']['temp'],
            },
            'weather': item['weather'],
          };
        } else {
          final temp = item['main']['temp'];
          if (temp < processedDailyData[dateKey]['temp']['min']) {
            processedDailyData[dateKey]['temp']['min'] = temp;
          }
          if (temp > processedDailyData[dateKey]['temp']['max']) {
            processedDailyData[dateKey]['temp']['max'] = temp;
          }
        }
      }

      // Convert processed daily data to list
      dailyData.addAll(processedDailyData.values);

      return {
        'current': currentData,
        'hourly': hourlyData,
        'daily': dailyData,
        'timezone': currentData['timezone'],
      };
    } catch (e) {
      print('Detailed weather error: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error getting detailed weather data: $e');
    }
  }
}

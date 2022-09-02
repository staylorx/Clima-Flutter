import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/utilities/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: false,
    printTime: false,
  ),
);

class WeatherModel {
  late int condition;
  late int temp;
  late String cityName;

  WeatherModel() {
    logger.d("New WeatherModel created.");
  }

  Future<void> getWeatherData({
    required double latitude,
    required double longitude,
  }) async {
    Position position = await determinePosition();

    /**
     * Fetch the weather data from OpenWeather
     */

    var params = {
      "lat": position.latitude,
      "long": position.longitude,
      "units": "imperial",
      "apiKey": kOpenWeatherAPIKey,
    };

    //https://www.kindacode.com/article/dart-convert-map-to-query-string-and-vice-versa
    final String queryString = Uri(
      queryParameters: params.map(
        (key, value) => MapEntry(
          key,
          value.toString(),
        ),
      ),
    ).query;

    NetworkHelper networkHelper = NetworkHelper();
    await networkHelper.get(
      "$kOpenWeatherURLBase?$queryString",
    );

    if (networkHelper.statusCode == 200) {
      //okay to use
      condition = networkHelper.result['main'];
      temp = networkHelper.result['main'];
      cityName = networkHelper.result['main'];
    }
  }

  String getWeatherIcon() {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage() {
    if (temp > 85) {
      return 'It\'s 🍦 time';
    } else if (temp > 70) {
      return 'Time for shorts and 👕';
    } else if (temp < 48) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}

import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/utilities/log_printer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

final logger = Logger(printer: MyLogfmtPrinter('weather'));

class WeatherModel {
  int condition = -999;
  double temp = -99.9;
  String cityName = '';
  String errMessage = '';

  Future<void> getCityWeather({required String typedName}) async {
    var params = {
      "q": typedName,
      "units": "imperial",
      "appid": dotenv.env['OPENWEATHER_APIKEY'] ?? "APIKEY_NOT_SET",
    };

    final String queryString = _convertQueryMapToString(params);

    final String url = "$kOpenWeatherURLBase?$queryString";
    logger.d("getCityWeather:url: $url");
    NetworkHelper networkHelper = NetworkHelper();
    await networkHelper.get(url);

    if (networkHelper.statusCode == 200) {
      //okay to use
      condition = networkHelper.result['weather'][0]['id'];
      temp = networkHelper.result['main']['temp'];
      cityName = networkHelper.result['name'];
      logger.d("getCityWeather: $this");
    } else {
      logger.e("getCityWeather: NetworkHelper did not return 200");
      if (networkHelper.statusCode == 404) {
        errMessage = "City not found.";
      }
    }
  }

  Future<void> getLocationWeather() async {
    //get the current condition
    Position position = await determinePosition();
    logger.d("getLocationWeather: $position");

    /**
     * Fetch the weather data from OpenWeather
     */
    var params = {
      "lat": position.latitude,
      "lon": position.longitude,
      "units": "imperial",
      "appid": dotenv.env['OPENWEATHER_APIKEY'] ?? "APIKEY_NOT_SET",
    };

    final String queryString = _convertQueryMapToString(params);

    final String url = "$kOpenWeatherURLBase?$queryString";
    logger.d("getLocationWeather:url: $url");
    NetworkHelper networkHelper = NetworkHelper();
    await networkHelper.get(url);

    if (networkHelper.statusCode == 200) {
      //okay to use
      condition = networkHelper.result['weather'][0]['id'];
      temp = networkHelper.result['main']['temp'];
      cityName = networkHelper.result['name'];
      logger.d("getLocationWeather: $this");
    } else {
      logger.e("getLocationWeather: NetworkHelper did not return 200");
    }
  }

  String _convertQueryMapToString(Map queryMap) {
    //https://www.kindacode.com/article/dart-convert-map-to-query-string-and-vice-versa
    final String queryString = Uri(
      queryParameters: queryMap.map(
        (key, value) => MapEntry(
          key,
          value.toString(),
        ),
      ),
    ).query;

    return queryString;
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

  @override
  String toString() {
    return "condition $condition, temp $temp, cityName $cityName";
  }
}

import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/log_printer.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:logger/logger.dart';

final logger = Logger(printer: MyLogfmtPrinter('location_screen'));

class LocationScreen extends StatefulWidget {
  final WeatherModel weatherModel;

  const LocationScreen({
    super.key,
    required this.weatherModel,
  });

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  String cityName = '';
  String temperature = '';
  String weatherIcon = '?';
  String weatherMessage = "Error";
  WeatherModel weather = WeatherModel();

  @override
  void initState() {
    super.initState();
    weather = widget.weatherModel;
    updateUI();
  }

  void updateUI() async {
    logger.d("UpdateUI: $weather");
    setState(() {
      temperature = weather.temp.toStringAsFixed(1);
      weatherIcon = weather.getWeatherIcon();
      weatherMessage = "${weather.getMessage()} in ${weather.cityName}!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      await weather.getLocationWeather();
                      setState(() {
                        updateUI();
                      });
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);

                      var typedName = await navigator.push(
                        MaterialPageRoute(builder: (context) {
                          return const CityScreen();
                        }),
                      );

                      if (typedName.isNotEmpty) {
                        await weather.getCityWeather(typedName: typedName);
                        logger.d(
                            "Back from city select using $typedName: $weather");
                      } else {
                        logger.i("typedName came back empty");
                      }

                      setState(() {
                        updateUI();
                      });
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  weatherMessage,
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

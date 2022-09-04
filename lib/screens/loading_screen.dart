import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/log_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

final logger = Logger(printer: MyLogfmtPrinter('loading_screen'));

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    getWeather();
    super.initState();
  }

  void getWeather() async {
    final navigator = Navigator.of(context);

    WeatherModel weatherModel = WeatherModel();
    await weatherModel.getLocationWeather();
    logger.d("loading_screen:getWeather: $weatherModel");

    navigator.push(MaterialPageRoute(
      builder: (context) {
        return LocationScreen(
          weatherModel: weatherModel,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          size: 100.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

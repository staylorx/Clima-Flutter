import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
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

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  CityScreenState createState() => CityScreenState();
}

class CityScreenState extends State<CityScreen> {
  TextEditingController cityName = TextEditingController();

  @override
  void initState() {
    cityName.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, cityName);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 50.0,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: null,
              ),
              //https://www.fluttercampus.com/guide/80/how-to-set-icon-on-textfield-widget-flutter/
              TextField(
                controller: cityName,
                decoration: const InputDecoration(
                  labelText: "Enter City Name",
                  labelStyle: kButtonTextStyle,
                  icon: Icon(Icons.location_city),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

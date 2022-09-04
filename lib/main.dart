import 'package:clima/utilities/log_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:clima/screens/loading_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

final logger = Logger(printer: MyLogfmtPrinter("main"));

Future<void> main() async {
  Logger.level = Level.debug;

  // https://developer.school/tutorials/how-to-use-environment-variables-with-flutter-dotenv
  if (kReleaseMode) {
    logger.d("main: Setting production mode");
    await dotenv.load(fileName: ".env.prod");
  } else {
    logger.d("main: Setting development mode");
    await dotenv.load(fileName: ".env.dev");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const LoadingScreen(),
    );
  }
}

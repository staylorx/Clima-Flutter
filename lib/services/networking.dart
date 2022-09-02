import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:http/retry.dart';

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

class NetworkHelper {
  late Map result;
  late int statusCode;

  Future<void> get(url) async {
    final client = RetryClient(http.Client());
    try {
      var response = await client.get(url);
      logger.d(response.statusCode);
      logger.d(response.body);
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
      }
    } finally {
      client.close();
    }
  }
}

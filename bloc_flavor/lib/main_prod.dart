import 'dart:io';
import 'package:flutter/material.dart';

import 'package:bloc_flavor/main.dart';
import 'models/app_config.dart';

void main() {
  const String kPort = '3010';
  final String baseUrl =
      Platform.isAndroid ? 'http://10.0.2.2:$kPort' : 'http://localhost:$kPort';
  final String dataUrl = '$baseUrl/prod';

  final appConfig = AppConfig(
    baseUrl: baseUrl,
    dataUrl: dataUrl,
    buildFlavor: 'prod',
  );

  runApp(MyApp(appConfig: appConfig));
}

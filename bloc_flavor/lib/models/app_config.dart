import 'package:flutter/foundation.dart';

class AppConfig {
  final String baseUrl;
  final String dataUrl;
  final String buildFlavor;

  AppConfig({
    @required this.baseUrl,
    @required this.dataUrl,
    @required this.buildFlavor,
  })  : assert(baseUrl != null),
        assert(dataUrl != null),
        assert(buildFlavor != null);
}

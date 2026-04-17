import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppApiClient {
  AppApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: _resolveBaseUrl(),
            connectTimeout: const Duration(seconds: 12),
            receiveTimeout: const Duration(seconds: 12),
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Accept'] = 'application/json';
          handler.next(options);
        },
      ),
    );
  }

  final Dio dio;

  static String _resolveBaseUrl() {
    if (kIsWeb) return 'http://localhost:3000';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }
}

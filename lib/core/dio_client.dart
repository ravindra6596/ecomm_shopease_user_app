import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/utils/apis.dart';

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  late Dio _dio;

  factory DioSingleton() {
    return _instance;
  }

  DioSingleton._internal() {
    _dio = Dio(
      BaseOptions(
          headers: {
            "Content-Type": "application/json",
          },
          connectTimeout: const Duration(seconds: 15000),
          receiveTimeout: const Duration(seconds: 15000),
          responseType: ResponseType.json,
          baseUrl: ApiConstants.baseUrl,
      ),
    )..interceptors.addAll([]);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SharedPrefHelper.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        logPrint: (obj) => log(obj.toString()),
      ),
    );
    log('URL ${ApiConstants.baseUrl}');
  }

  Dio get dio => _dio;

  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    log("Dio base URL updated to: $baseUrl");
  }
}

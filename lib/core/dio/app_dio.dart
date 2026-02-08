import 'package:dio/dio.dart';
import 'package:dio_curl_logger/dio_curl_logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:movie/core/dio/interceptor.dart';

abstract class AppNetworkModule {
  static Dio provideDio() {
    Dio dio = Dio(
      BaseOptions(
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(RequestInterceptor());
    dio.interceptors.add(
      CurlLoggingInterceptor(
        showRequestLog:
            true, // Set to false to disable logging of HTTP requests
        showResponseLog:
            false, // Set to false to disable logging of HTTP responses
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
    return dio;
  }
}

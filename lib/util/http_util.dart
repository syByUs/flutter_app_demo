import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

var dio = Dio();

class HttpUtil {
  HttpUtil._();

  static void init() {
    // add interceptors
    dio
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ))
      // ..interceptors.add(HttpFormatter())
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        // Do something before request is sent
        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response); // continue
      }, onError: (DioError e, handler) {
        // Do something with response error
        return handler.next(e); //continue
      }));

    // 配置dio实例
    dio.options.baseUrl = "https://itunes.apple.com";
    dio.options.connectTimeout = 30000; //30s
    dio.options.receiveTimeout = 30000;
  }

  /// get
  static Future<Map<String, dynamic>> get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var result = await dio.get<String>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      print(result.realUri);
      if (result.data == null) {
        throw PlatformException(code: "result error");
      }
      Map<String, dynamic> map = json.decode(result.data!);
      return map;
    } catch (error) {
      return Future.error(error);
    }
  }

}

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'network_exception.dart';
import '../enums/network_error_type.dart';
import '../enums/http_method.dart';

class DioClient {
  late final Dio dio;
  static DioClient? _instance;

  DioClient._internal(){
    BaseOptions options = BaseOptions(
        baseUrl: 'https://itunes.apple.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        }
    );
    dio = Dio(options);
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      responseBody: true,
      error: true,
    ));
    dio.interceptors.add(InterceptorsWrapper(
        onResponse: (response, handler) {
          if (response.data is String) {
            try {
              response.data = jsonDecode(response.data);
            } catch (e) {
              debugPrint("Could not parse string to JSON");
            }
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          final networkException = NetworkException.fromDioError(error);
          String errorMessage = networkException.message;

          Fluttertoast.showToast( // shared
            msg: errorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return handler.next(error);
        }
    ));
  }

  factory DioClient() {
    if (_instance == null) {
      _instance = DioClient._internal();
    }
    return _instance!;
  }

  /*String getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response
            ?.statusCode}. Please try again later.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.unknown:
        return 'An unexpected network error occurred.';
      default:
        return 'Something went wrong.';
    }*/

  /*Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get<T>(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(
          message: 'Unexpected parsing error: $e',
          type: NetworkErrorType.unknown
      );
    }
  }*/

  Future<Response<T>> request<T>({
    required HttpMethod method,
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      switch (method) {
        case HttpMethod.get:
          return await dio.get<T>(path, queryParameters: queryParameters);
        case HttpMethod.post:
          return await dio.post<T>(path, data: data, queryParameters: queryParameters);
        case HttpMethod.put:
          return await dio.put<T>(path, data: data, queryParameters: queryParameters);
        case HttpMethod.patch:
          return await dio.patch<T>(path, data: data, queryParameters: queryParameters);
        case HttpMethod.delete:
          return await dio.delete<T>(path, data: data, queryParameters: queryParameters);
      }
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(
        message: 'Unexpected parsing error: $e',
        type: NetworkErrorType.unknown,
      );
    }
  }

}




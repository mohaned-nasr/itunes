import 'package:dio/dio.dart';
import '../enums/network_error_type.dart';
class NetworkException implements Exception {
  final String message;
  final NetworkErrorType type;
  final int? statusCode;

  NetworkException({
    required this.message,
    required this.type,
    this.statusCode
  });

  factory NetworkException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
            message: 'Connection timed out. Please check your internet.',
            type: NetworkErrorType.timeout
        );
      case DioExceptionType.connectionError:
        return NetworkException(
            message: 'No internet connection.',
            type: NetworkErrorType.noConnection
        );
      case DioExceptionType.cancel:
        return NetworkException(
            message: 'Request cancelled.',
            type: NetworkErrorType.cancelled
        );
      case DioExceptionType.badResponse:
        return NetworkException._fromStatusCode(error.response?.statusCode);
      default:
        return NetworkException(
            message: 'An unexpected network error occurred.',
            type: NetworkErrorType.unknown
        );
    }
  }
  factory NetworkException._fromStatusCode(int? code) {
    switch (code) {
      case 400:
        return NetworkException(message: 'Bad request', type: NetworkErrorType.badRequest, statusCode: 400);
      case 401:
        return NetworkException(message: 'Unauthorized', type: NetworkErrorType.unauthorized, statusCode: 401);
      case 403:
        return NetworkException(message: 'Forbidden', type: NetworkErrorType.forbidden, statusCode: 403);
      case 404:
        return NetworkException(message: 'Not found', type: NetworkErrorType.notFound, statusCode: 404);
      default:
        return NetworkException(message: 'Server error: $code', type: NetworkErrorType.serverError, statusCode: code);
    }
  }

  @override
  String toString() => message;

}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/core/services/storage_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.1.3:8000/api/v1",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  final storageService = ref.watch(storageServiceProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = storageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
          'DIO_RESPONSE: ${response.statusCode} ${response.requestOptions.path}',
        );
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('DIO_ERROR: ${e.message} ${e.requestOptions.path}');

        if (e.response != null) {
          print('DIO_ERROR_DATA: ${e.response?.data}');
        }

        return handler.next(e);
      },
    ),
  );

  return dio;
});

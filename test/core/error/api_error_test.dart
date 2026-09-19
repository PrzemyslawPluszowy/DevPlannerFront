import 'package:devplanner/foundation/error/error.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiError.fromDioException', () {
    test('mapuje connection timeout', () {
      final error = DioException.connectionTimeout(
        timeout: const Duration(seconds: 15),
        requestOptions: RequestOptions(path: '/api/test'),
      );

      final result = ApiError.fromDioException(
        error,
        fallbackMessage: 'Fallback',
      );

      expect(result.type, ApiErrorType.connectionTimeout);
      expect(result.message, 'Przekroczono czas polaczenia z serwerem.');
    });

    test('zwraca komunikat z backendu dla bad response', () {
      final error = DioException.badResponse(
        statusCode: 422,
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 422,
          data: {
            'error': {
              'code': 1001,
              'message': 'Backend walidacji odrzucil dane.',
            },
          },
        ),
      );

      final result = ApiError.fromDioException(
        error,
        fallbackMessage: 'Fallback',
      );

      expect(result.type, ApiErrorType.validation);
      expect(result.backendCode, 1001);
      expect(result.message, 'Backend walidacji odrzucil dane.');
    });

    test('gdy brak komunikatu z backendu, uzywa fallbacku ze statusu', () {
      final error = DioException.badResponse(
        statusCode: 404,
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 404,
          data: <String, dynamic>{},
        ),
      );

      final result = ApiError.fromDioException(
        error,
        fallbackMessage: 'Fallback',
      );

      expect(result.type, ApiErrorType.notFound);
      expect(result.message, 'Nie znaleziono zasobu.');
    });

    test('skleja bledy walidacyjne z detail', () {
      final error = DioException.badResponse(
        statusCode: 422,
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 422,
          data: {
            'detail': [
              {
                'loc': ['query', 'firma'],
                'msg': 'Pole firma jest wymagane',
                'type': 'missing',
              },
              {
                'loc': ['query', 'status'],
                'msg': 'Nieprawidlowy status',
                'type': 'invalid',
              },
            ],
          },
        ),
      );

      final result = ApiError.fromDioException(
        error,
        fallbackMessage: 'Fallback',
      );

      expect(result.type, ApiErrorType.validation);
      expect(
        result.message,
        'Pole firma jest wymagane\nNieprawidlowy status',
      );
    });

    test('wyciaga komunikaty walidacji z laravelowego pola errors', () {
      final error = DioException.badResponse(
        statusCode: 422,
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 422,
          data: {
            'message': 'The given data was invalid.',
            'errors': {
              'selected_standard_ids': [
                'Przynajmniej jedna pozycja standardu nie należy do aktywnego standardu pracownika.',
              ],
              'id': [
                'Nie można usunąć aktywnej pozycji standardu. Najpierw ją zarchiwizuj.',
              ],
            },
          },
        ),
      );

      final result = ApiError.fromDioException(
        error,
        fallbackMessage: 'Fallback',
      );

      expect(result.type, ApiErrorType.validation);
      expect(
        result.message,
        'Przynajmniej jedna pozycja standardu nie należy do aktywnego standardu pracownika.\n'
        'Nie można usunąć aktywnej pozycji standardu. Najpierw ją zarchiwizuj.',
      );
    });
  });

  group('ApiError.parsing', () {
    test('tworzy blad parsowania z dedykowanym typem', () {
      final result = ApiError.parsing(
        fallbackMessage: 'Backend zwrocil nieprawidlowe dane.',
      );

      expect(result.type, ApiErrorType.parsing);
      expect(result.message, 'Backend zwrocil nieprawidlowe dane.');
      expect(result.statusCode, isNull);
      expect(result.backendCode, isNull);
    });
  });
}

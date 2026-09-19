import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';

/// Otwieranie podglądu w domyślnej aplikacji Windows/macOS/Linux.
final class StorageExternalUrlPlatform {
  const StorageExternalUrlPlatform._();

  static Future<Either<ApiError, Unit>> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'https' && uri.scheme != 'http')) {
      return const Left(
        ApiError(
          type: ApiErrorType.validation,
          message: 'Nieprawidłowy adres podglądu.',
        ),
      );
    }
    try {
      final normalized = uri.toString();
      final process = switch (Platform.operatingSystem) {
        'macos' => await Process.start('open', [normalized]),
        'windows' => await Process.start('cmd', [
          '/c',
          'start',
          '',
          normalized,
        ]),
        'linux' => await Process.start('xdg-open', [normalized]),
        _ => throw UnsupportedError('Nieobsługiwana platforma desktopowa.'),
      };
      final exitCode = await process.exitCode;
      return exitCode == 0
          ? const Right(unit)
          : Left(
              ApiError(
                type: ApiErrorType.unknown,
                message: 'System nie otworzył podglądu (kod $exitCode).',
              ),
            );
    } on Object catch (error) {
      return Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Nie udało się otworzyć podglądu: $error',
        ),
      );
    }
  }
}

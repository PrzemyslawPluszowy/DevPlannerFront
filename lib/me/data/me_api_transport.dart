import 'dart:typed_data';

/// Metody HTTP wspierane przez transport profilu użytkownika.
enum MeApiMethod { get, post, patch, put, delete }

/// Niskopoziomowe żądanie przekazywane do implementacji transportu API.
final class MeApiRequest {
  const MeApiRequest({
    required this.method,
    required this.path,
    this.query = const <String, String>{},
    this.body,
    this.rawBytes,
    this.contentType,
    this.filename,
  });

  final MeApiMethod method;
  final String path;
  final Map<String, String> query;
  final Map<String, Object?>? body;
  final Uint8List? rawBytes;
  final String? contentType;
  final String? filename;
}

/// Niskopoziomowa odpowiedź transportu API.
final class MeApiResponse {
  const MeApiResponse({
    required this.statusCode,
    this.body,
  });

  final int statusCode;
  final Object? body;
}

/// Kontrakt transportu HTTP/BFF dla zapytań profilu i sesji.
// ignore: one_member_abstracts
abstract interface class MeApiTransport {
  Future<MeApiResponse> send(MeApiRequest request);
}

// Retrofit wymaga abstrakcyjnego interfejsu dla każdego klienta HTTP.
// ignore_for_file: one_member_abstracts

import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_directory_api.g.dart';

/// Kontrakt katalogu kont dostępnych do rozmów.
@RestApi()
abstract class ChatDirectoryApi {
  /// Tworzy klienta katalogu Chat na sesyjnym transporcie HTTP.
  factory ChatDirectoryApi(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _ChatDirectoryApi;

  /// Pobiera lokalne konta pasujące do frazy.
  @GET('/api/v1/chat/users')
  Future<List<ChatDirectoryUserResponse>> searchDirectory({
    @Query('q') required String query,
    @Query('limit') int? limit,
  });
}

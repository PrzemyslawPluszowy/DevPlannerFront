// Retrofit wymaga abstrakcyjnej klasy nawet dla klienta z jednym endpointem.
// ignore_for_file: one_member_abstracts

import 'package:devplanner/workspaces/data/auth/models/auth_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

/// Klient Retrofit zweryfikowanej tożsamości lokalnego DevPlanner.
@RestApi()
abstract class AuthApi {
  /// Tworzy klienta API Auth.
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  /// Pobiera profil i prawa bieżącego użytkownika.
  @GET('/api/v1/auth/me')
  Future<CurrentUserResponse> me();
}

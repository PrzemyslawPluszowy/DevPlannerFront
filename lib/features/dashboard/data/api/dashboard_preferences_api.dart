import 'package:dio/dio.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:retrofit/retrofit.dart';

part 'dashboard_preferences_api.g.dart';

/// Klient Retrofit dla prywatnego pulpitu użytkownika w Veloryn Core.
@RestApi()
abstract class DashboardPreferencesApi {
  /// Tworzy klienta na bazie uwierzytelnionego klienta Dio Core.
  factory DashboardPreferencesApi(Dio dio, {String? baseUrl}) =
      _DashboardPreferencesApi;

  /// Pobiera aktualny dokument pulpitu zalogowanego użytkownika.
  @GET('/me/dashboard')
  Future<RemoteDashboardPreferences> getPreferences();

  /// Tworzy lub warunkowo aktualizuje dokument pulpitu.
  @PUT('/me/dashboard')
  Future<RemoteDashboardPreferences> putPreferences(
    @Body() PutDashboardPreferencesRequest request,
  );
}

/// Wersjonowany dokument pulpitu zwracany przez Veloryn Core.
class RemoteDashboardPreferences {
  /// Tworzy model odpowiedzi endpointu pulpitu.
  const RemoteDashboardPreferences({
    required this.schemaVersion,
    required this.revision,
    required this.preferences,
    required this.updatedAtUtc,
  });

  /// Odtwarza model odpowiedzi z JSON.
  factory RemoteDashboardPreferences.fromJson(Map<String, dynamic> json) {
    return RemoteDashboardPreferences(
      schemaVersion: (json['schemaVersion'] as num).toInt(),
      revision: (json['revision'] as num).toInt(),
      preferences: DashboardPreferences.fromJson(
        Map<String, dynamic>.from(json['preferences'] as Map),
      ),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
    );
  }

  /// Wersja formatu całego dokumentu dashboardu.
  final int schemaVersion;

  /// Rewizja używana do bezpiecznej aktualizacji dokumentu.
  final int revision;

  /// Konfiguracja pulpitu.
  final DashboardPreferences preferences;

  /// Czas ostatniego zapisu po stronie Core.
  final DateTime updatedAtUtc;
}

/// Payload warunkowego zapisu pulpitu do Veloryn Core.
class PutDashboardPreferencesRequest {
  /// Tworzy payload zgodny z kontraktem `PUT /me/dashboard`.
  const PutDashboardPreferencesRequest({
    required this.schemaVersion,
    required this.revision,
    required this.preferences,
  });

  /// Wersja formatu dokumentu dashboardu.
  final int schemaVersion;

  /// Rewizja ostatnio odczytana z Core; `0` oznacza pierwszy zapis.
  final int revision;

  /// Konfiguracja pulpitu do zapisania.
  final DashboardPreferences preferences;

  /// Zamienia payload na format JSON używany przez Retrofit.
  Map<String, dynamic> toJson() => {
    'schemaVersion': schemaVersion,
    'revision': revision,
    'preferences': preferences.toJson(),
  };
}

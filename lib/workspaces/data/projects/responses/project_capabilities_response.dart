import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_capabilities_response.freezed.dart';
part 'project_capabilities_response.g.dart';

/// Możliwości bieżącego użytkownika względem projektu.
///
/// Kontrakt C#: `ProjectCapabilitiesResponse`. Backend traktuje je jako
/// discoverability — nadal sprawdza własne ACL na każdym endpointcie.
///
/// Pola mają wartość domyślną `false`, więc częściowa lub nieznana odpowiedź
/// degraduje się do zachowania zachowawczego zamiast rzucać wyjątkiem parsowania.
@freezed
abstract class ProjectCapabilitiesResponse with _$ProjectCapabilitiesResponse {
  /// Tworzy zestaw możliwości projektu.
  const factory ProjectCapabilitiesResponse({
    /// Czy użytkownik może zmieniać dane aktywnego projektu.
    @Default(false) bool canManage,

    /// Czy użytkownik może archiwizować i przywracać projekt.
    @Default(false) bool canArchive,

    /// Czy użytkownik może trwale usunąć zarchiwizowany projekt.
    @Default(false) bool canDelete,

    /// Czy użytkownik może zarządzać członkami projektu.
    @Default(false) bool canManageMembers,

    /// Czy użytkownik może zapisać szablon z projektu.
    @Default(false) bool canCreateTemplate,

    /// Czy użytkownik ma jawne członkostwo projektu, które może opuścić.
    @Default(false) bool canLeave,

    /// Zarezerwowane dla transferu projektu; obecnie zawsze `false`.
    @Default(false) bool canTransfer,
  }) = _ProjectCapabilitiesResponse;

  /// Odtwarza możliwości projektu z odpowiedzi JSON Workspaces.
  factory ProjectCapabilitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectCapabilitiesResponseFromJson(json);
}

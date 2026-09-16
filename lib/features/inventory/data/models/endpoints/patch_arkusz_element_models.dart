import 'package:json_annotation/json_annotation.dart';

import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';

part 'patch_arkusz_element_models.g.dart';

/// Query dla `PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class PatchArkuszElementQuery {
  const PatchArkuszElementQuery({
    this.stanInwent,
    this.statusSpisu,
    this.likwidacja,
    this.nadwyzka,
    this.nrewid,
    this.nowyKodKreskowy,
    this.nowaOsoba,
    this.nowaNazwa,
    this.uwagiLoc,
    this.kkWczytany,
    this.nadwIdmiejsce,
    this.nadwIdFirmy,
  });

  factory PatchArkuszElementQuery.fromJson(Map<String, dynamic> json) =>
      _$PatchArkuszElementQueryFromJson(json);

  /// Kod stanu inwentaryzacyjnego wysylany do backendu.
  @JsonKey(
    name: 'stan_inwent',
    fromJson: _arkuszElementInwentStatusFromJson,
    toJson: _arkuszElementInwentStatusToJson,
  )
  final ArkuszElementInwentStatus? stanInwent;

  /// Status spisu elementu wysylany do backendu.
  @JsonKey(name: 'status_spisu')
  @ArkuszElementStatusSpisuConverter()
  final ArkuszElementStatusSpisu? statusSpisu;

  /// Flaga usuniecia/likwidacji wysylana do backendu.
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  final bool? likwidacja;

  /// Flaga oznaczajaca element jako nadwyzke.
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  final bool? nadwyzka;
  final String? nrewid;
  final String? nowyKodKreskowy;
  final String? nowaOsoba;
  final String? nowaNazwa;
  final String? uwagiLoc;

  /// Flaga informujaca backend, czy element zostal wczytany skanerem.
  @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
  final bool? kkWczytany;
  final int? nadwIdmiejsce;
  final int? nadwIdFirmy;
  Map<String, dynamic> toJson() => _$PatchArkuszElementQueryToJson(this);

  /// Czy element jest oznaczony jako zlikwidowany.
  bool get isLiquidated => likwidacja ?? false;

  /// Czy element jest oznaczony jako nadwyzka.
  bool get hasSurplus => nadwyzka ?? false;

  /// Czy element zostal wczytany przez skaner.
  bool get isScanned => kkWczytany ?? false;

  /// Czytelny status inwentaryzacyjny do UI i logiki aplikacji.
  ArkuszElementInwentStatus? get inventoryStatus => stanInwent;
}

/// Odpowiedz po zapisaniu pojedynczego elementu arkusza.
///
/// Backend zwraca tylko identyfikator zmodyfikowanego elementu i flage
/// powodzenia, bez pelnego payloadu elementu.
@JsonSerializable(fieldRename: FieldRename.snake)
class PatchArkuszElementResponseData {
  const PatchArkuszElementResponseData({
    required this.elementId,
    this.success = true,
  });

  factory PatchArkuszElementResponseData.fromJson(Map<String, dynamic> json) =>
      _$PatchArkuszElementResponseDataFromJson(json);

  /// Flaga powodzenia operacji zapisu.
  final bool success;

  /// Identyfikator elementu, ktory zostal zaktualizowany.
  final int elementId;
  Map<String, dynamic> toJson() => _$PatchArkuszElementResponseDataToJson(this);
}

ArkuszElementInwentStatus? _arkuszElementInwentStatusFromJson(Object? value) =>
    ArkuszElementInwentStatus.fromApi(value);

String? _arkuszElementInwentStatusToJson(ArkuszElementInwentStatus? status) =>
    status?.apiValue;

bool? _boolFromJson(Object? value) => switch (value) {
  final bool boolValue => boolValue,
  final int intValue => intValue == 1,
  final String stringValue =>
    stringValue == '1' || stringValue.toLowerCase() == 'true',
  _ => null,
};

bool? _boolToJson(bool? value) => value;

import 'package:json_annotation/json_annotation.dart';

part 'get_bhp_positions_models.g.dart';

/// Rekord listy stanowisk BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpPositionListItem {
  /// Tworzy rekord stanowiska BHP.
  const GetBhpPositionListItem({
    required this.id,
    required this.nazwa,
    required this.aktywny,
    this.uwagi,
    this.pracownicyCount,
  });

  /// Tworzy rekord z JSON.
  factory GetBhpPositionListItem.fromJson(Map<String, dynamic> json) =>
      _$GetBhpPositionListItemFromJson(json);

  /// Id stanowiska.
  final int id;

  /// Nazwa stanowiska.
  final String nazwa;

  /// Uwagi.
  final String? uwagi;

  /// Flaga aktywności.
  final bool aktywny;

  /// Liczba przypisanych pracowników.
  final int? pracownicyCount;

  /// Tworzy kopię obiektu z nadpisanymi polami.
  GetBhpPositionListItem copyWith({
    int? id,
    String? nazwa,
    bool? aktywny,
    String? uwagi,
    int? pracownicyCount,
  }) {
    return GetBhpPositionListItem(
      id: id ?? this.id,
      nazwa: nazwa ?? this.nazwa,
      aktywny: aktywny ?? this.aktywny,
      uwagi: uwagi ?? this.uwagi,
      pracownicyCount: pracownicyCount ?? this.pracownicyCount,
    );
  }

  /// Serializuje rekord do JSON.
  Map<String, dynamic> toJson() => _$GetBhpPositionListItemToJson(this);
}

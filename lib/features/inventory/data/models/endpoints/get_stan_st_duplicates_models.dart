class GetStanStDuplicatesResponseData {
  const GetStanStDuplicatesResponseData({
    required this.items,
    required this.meta,
  });

  factory GetStanStDuplicatesResponseData.fromJson(Map<String, dynamic> json) {
    return GetStanStDuplicatesResponseData(
      items: ((json['items'] as List<dynamic>?) ?? const [])
          .map(
            (item) => GetStanStDuplicateGroup.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
      meta: GetStanStDuplicatesMeta.fromJson(
        (json['meta'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }

  final List<GetStanStDuplicateGroup> items;
  final GetStanStDuplicatesMeta meta;
}

class GetStanStDuplicatesMeta {
  const GetStanStDuplicatesMeta({
    required this.totalGroups,
    required this.totalEntries,
  });

  factory GetStanStDuplicatesMeta.fromJson(Map<String, dynamic> json) {
    return GetStanStDuplicatesMeta(
      totalGroups: (json['total_groups'] as num?)?.toInt() ?? 0,
      totalEntries: (json['total_entries'] as num?)?.toInt() ?? 0,
    );
  }

  final int totalGroups;
  final int totalEntries;
}

class GetStanStDuplicateGroup {
  const GetStanStDuplicateGroup({
    required this.nrewid,
    required this.normalizedNrewid,
    required this.nrewidVariants,
    required this.firmy,
    required this.duplicatesCount,
    required this.entries,
  });

  factory GetStanStDuplicateGroup.fromJson(Map<String, dynamic> json) {
    return GetStanStDuplicateGroup(
      nrewid: (json['nrewid'] as String?) ?? '',
      normalizedNrewid: (json['normalized_nrewid'] as String?) ?? '',
      nrewidVariants: ((json['nrewid_variants'] as List<dynamic>?) ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
      firmy: ((json['firmy'] as List<dynamic>?) ?? const [])
          .map((item) => (item as num).toInt())
          .toList(growable: false),
      duplicatesCount: (json['duplicates_count'] as num?)?.toInt() ?? 0,
      entries: ((json['entries'] as List<dynamic>?) ?? const [])
          .map(
            (item) =>
                GetStanStDuplicateEntry.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  final String nrewid;
  final String normalizedNrewid;
  final List<String> nrewidVariants;
  final List<int> firmy;
  final int duplicatesCount;
  final List<GetStanStDuplicateEntry> entries;
}

class GetStanStDuplicateEntry {
  const GetStanStDuplicateEntry({
    required this.id,
    this.baza,
    this.firma,
    this.firmaNazwa,
    this.nazwa,
    this.nrewid,
    this.osoba,
    this.idmiejsce,
    this.miejsce,
    this.lvl,
    this.kodKreskowy,
    this.wartoscP,
    this.wartoscA,
    this.dataImportu,
  });

  factory GetStanStDuplicateEntry.fromJson(Map<String, dynamic> json) {
    return GetStanStDuplicateEntry(
      id: (json['id'] as num?)?.toInt() ?? 0,
      baza: json['baza'] as String?,
      firma: (json['firma'] as num?)?.toInt(),
      firmaNazwa: json['firma_nazwa'] as String?,
      nazwa: json['nazwa'] as String?,
      nrewid: json['nrewid'] as String?,
      osoba: json['osoba'] as String?,
      idmiejsce: (json['idmiejsce'] as num?)?.toInt(),
      miejsce: json['miejsce'] as String?,
      lvl: json['lvl'] as String?,
      kodKreskowy: (json['kod_kreskowy'] as num?)?.toInt(),
      wartoscP: _decimalStringFromJson(json['wartosc_p']),
      wartoscA: _decimalStringFromJson(json['wartosc_a']),
      dataImportu: json['data_importu'] as String?,
    );
  }

  final int id;
  final String? baza;
  final int? firma;
  final String? firmaNazwa;
  final String? nazwa;
  final String? nrewid;
  final String? osoba;
  final int? idmiejsce;
  final String? miejsce;
  final String? lvl;
  final int? kodKreskowy;
  final String? wartoscP;
  final String? wartoscA;
  final String? dataImportu;
}

String? _decimalStringFromJson(Object? value) => switch (value) {
  null => null,
  final String stringValue => stringValue,
  final num numValue => numValue.toString(),
  _ => value.toString(),
};

import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_elementy_models.dart';

void main() {
  group('PostArkuszElementyQuery', () {
    test(
      'toJson mapuje opcjonalne data_zakupu zgodnie z kontraktem backendu',
      () {
        const query = PostArkuszElementyQuery(
          kodKreskowy: 0,
          dataZakupu: '2026-04-20',
          nrewid: 'MANUAL/001',
          nazwa: 'Nadwyzka testowa',
          osoba: 'Jan Testowy',
        );

        final json = query.toJson();

        expect(json['kod_kreskowy'], 0);
        expect(json['data_zakupu'], '2026-04-20');
        expect(json['nrewid'], 'MANUAL/001');
      },
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_models.dart';

void main() {
  group('PostArkuszQuery', () {
    test('toJson mapuje id_firmy i baza zgodnie z kontraktem', () {
      const query = PostArkuszQuery(
        idMiejsca: 61,
        idFirmy: 4,
        baza: 'SZKLO',
        scope: 'node',
      );

      final json = query.toJson();

      expect(json['id_miejsca'], 61);
      expect(json['id_firmy'], 4);
      expect(json['baza'], 'SZKLO');
      expect(json['scope'], 'node');
    });
  });
}

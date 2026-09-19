import 'package:devplanner/core/data/api_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('debugResponseShape', () {
    test('podaje nazwy pól, ale nigdy ich wartości', () {
      final shape = debugResponseShape({
        'access_token': 'secret-token-value',
        'email': 'ktos@example.com',
        'password': 'Haslo#2026',
      });

      expect(shape, 'fields=access_token,email,password');
      expect(shape, isNot(contains('secret-token-value')));
      expect(shape, isNot(contains('ktos@example.com')));
      expect(shape, isNot(contains('Haslo#2026')));
    });

    test('dla tekstu i listy zdradza wyłącznie rozmiar', () {
      expect(debugResponseShape('token=abc123'), 'text=12b');
      expect(debugResponseShape(['a', 'b', 'c']), 'items=3');
      expect(debugResponseShape(null), 'brak');
    });

    test('długie mapowanie ucina listę pól', () {
      final shape = debugResponseShape({
        for (var index = 0; index < 20; index++) 'field$index': index,
      });

      expect(shape, startsWith('fields=field0,'));
      expect(shape, endsWith('…'));
      expect(shape.split(','), hasLength(12));
    });
  });
}

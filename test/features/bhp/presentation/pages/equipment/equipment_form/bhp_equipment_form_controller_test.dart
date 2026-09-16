import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/equipment_form/bhp_equipment_form_controller.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

void main() {
  group('BhpEquipmentFormController', () {
    test('buildRequest: zachowuje całkowity procent przydatności', () {
      final controller = BhpEquipmentFormController();
      addTearDown(controller.dispose);

      controller.symbolController.text = 'KASK';
      controller.nazwaController.text = 'Kask';
      controller.procentPrzydatnosciController.text = '12';

      final request = controller.buildRequest();

      expect(request.procentPrzydatnosci, 12);
    });
  });

  group('AppValidators.nonNegativeInteger', () {
    test('odrzuca wartości dziesiętne', () {
      final validator = AppValidators.nonNegativeInteger();

      expect(
        validator('12.5'),
        'Podaj liczbę całkowitą >= 0.',
      );
    });

    test('akceptuje zero', () {
      final validator = AppValidators.nonNegativeInteger();

      expect(validator('0'), isNull);
    });
  });
}

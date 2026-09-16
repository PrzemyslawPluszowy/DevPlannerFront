import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/create_arkusz/create_arkusz_tree_utils.dart';

void main() {
  const root = GetMiejscaItem(
    id: 1,
    idMiejsca: 100,
    idFirmy: 2,
    idparent: 0,
    nazwa: 'Root',
  );
  const child = GetMiejscaItem(
    id: 2,
    idMiejsca: 101,
    idFirmy: 2,
    idparent: 1,
    nazwa: 'Child',
  );
  const leaf = GetMiejscaItem(
    id: 3,
    idMiejsca: 102,
    idFirmy: 2,
    idparent: 2,
    nazwa: 'Leaf',
  );

  const placeParentRoot = GetMiejscaItem(
    id: 10,
    idMiejsca: 200,
    idFirmy: 2,
    idparent: 0,
    nazwa: 'RootPlace',
  );
  const placeParentChild = GetMiejscaItem(
    id: 11,
    idMiejsca: 201,
    idFirmy: 2,
    idparent: 200,
    nazwa: 'ChildPlace',
  );

  group('createArkuszParentUsesRecordId', () {
    test(
      'zwraca true gdy idparent wiekszosciowo wskazuje na id rekordu (wykrywa bledna interpretacje parenta)',
      () {
        final result = createArkuszParentUsesRecordId([
          root,
          child,
          leaf,
        ]);

        expect(result, isTrue);
      },
    );

    test(
      'zwraca false gdy idparent wiekszosciowo wskazuje na id_miejsca (wykrywa regresje dla danych place-keyed)',
      () {
        final result = createArkuszParentUsesRecordId([
          placeParentRoot,
          placeParentChild,
        ]);

        expect(result, isFalse);
      },
    );
  });

  group('createArkuszTreeKey', () {
    test('dla trybu record-key zwraca id rekordu', () {
      expect(createArkuszTreeKey(child, true), 2);
    });

    test('dla trybu place-key zwraca id_miejsca', () {
      expect(createArkuszTreeKey(child, false), 101);
    });
  });

  group('createArkuszScopedTreeKey', () {
    test(
      'rozdziela te same id_miejsca i idparent miedzy bazami',
      () {
        const profileRoot = GetMiejscaItem(
          id: 25380,
          idMiejsca: 1,
          idFirmy: 2,
          idparent: 0,
          baza: 'PROFILE',
          nazwa: 'Drwina',
        );
        const wyposazenieRoot = GetMiejscaItem(
          id: 25425,
          idMiejsca: 1,
          idFirmy: 2,
          idparent: 0,
          baza: 'WYPOSAZENIE',
          nazwa: 'Drwina',
        );
        const profileChild = GetMiejscaItem(
          id: 25384,
          idMiejsca: 5,
          idFirmy: 2,
          idparent: 1,
          baza: 'PROFILE',
          nazwa: 'Biura',
        );
        const wyposazenieChild = GetMiejscaItem(
          id: 25429,
          idMiejsca: 5,
          idFirmy: 2,
          idparent: 1,
          baza: 'WYPOSAZENIE',
          nazwa: 'Biura',
        );

        final parentUsesRecordId = createArkuszParentUsesRecordId([
          profileRoot,
          wyposazenieRoot,
          profileChild,
          wyposazenieChild,
        ]);
        final profileRootKey = createArkuszScopedTreeKey(
          profileRoot,
          parentUsesRecordId,
        );
        final wyposazenieRootKey = createArkuszScopedTreeKey(
          wyposazenieRoot,
          parentUsesRecordId,
        );

        expect(parentUsesRecordId, isFalse);
        expect(createArkuszScopedParentKey(profileChild), profileRootKey);
        expect(
          createArkuszScopedParentKey(wyposazenieChild),
          wyposazenieRootKey,
        );
        expect(
          createArkuszScopedParentKey(profileChild),
          isNot(wyposazenieRootKey),
        );
        expect(
          createArkuszScopedParentKey(wyposazenieChild),
          isNot(profileRootKey),
        );
      },
    );
  });

  group('createArkuszResolveLocationScope', () {
    test(
      'zwraca node gdy selectedLocationId jest null (bez wyboru nie mozna zakladac subtree)',
      () {
        final scope = createArkuszResolveLocationScope(
          locations: const [root, child, leaf],
          selectedLocationId: null,
        );

        expect(scope, 'node');
      },
    );

    test(
      'zwraca node gdy wybrany node ma dzieci (kazda galaz jest osobnym arkuszem)',
      () {
        final scope = createArkuszResolveLocationScope(
          locations: const [root, child, leaf],
          selectedLocationId: 2,
        );

        expect(scope, 'node');
      },
    );

    test(
      'zwraca node gdy wybrane miejsce jest lisciem (wykrywa nadmierne rozszerzanie zakresu)',
      () {
        final scope = createArkuszResolveLocationScope(
          locations: const [root, child, leaf],
          selectedLocationId: 3,
        );

        expect(scope, 'node');
      },
    );

    test(
      'zwraca node gdy selectedLocationId nie istnieje w slowniku (wykrywa crash na niespojnym wyborze UI)',
      () {
        final scope = createArkuszResolveLocationScope(
          locations: const [root, child, leaf],
          selectedLocationId: 99999,
        );

        expect(scope, 'node');
      },
    );

    test(
      'zwraca node takze gdy parent wskazuje na id_miejsca',
      () {
        final scope = createArkuszResolveLocationScope(
          locations: const [placeParentRoot, placeParentChild],
          selectedLocationId: 10,
        );

        expect(scope, 'node');
      },
    );

    test(
      'nie wykrywa subtree po dzieciach z innej bazy',
      () {
        const profileRoot = GetMiejscaItem(
          id: 25380,
          idMiejsca: 1,
          idFirmy: 2,
          idparent: 0,
          baza: 'PROFILE',
          nazwa: 'Drwina',
        );
        const wyposazenieChild = GetMiejscaItem(
          id: 25429,
          idMiejsca: 5,
          idFirmy: 2,
          idparent: 1,
          baza: 'WYPOSAZENIE',
          nazwa: 'Biura',
        );

        final scope = createArkuszResolveLocationScope(
          locations: const [profileRoot, wyposazenieChild],
          selectedLocationId: 25380,
        );

        expect(scope, 'node');
      },
    );
  });
}

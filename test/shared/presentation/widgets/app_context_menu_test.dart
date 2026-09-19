import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? MaterialTheme.crm().light(),
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [Locale('pl')],
  home: Scaffold(body: Align(alignment: Alignment.topLeft, child: child)),
);

/// Kotwica menu: przycisk otwierający menu i własny węzeł focusu.
class _MenuAnchor extends StatefulWidget {
  const _MenuAnchor({
    required this.actions,
    required this.options,
    this.regionActions,
    this.onSelected,
  });

  final List<AppContextMenuAction> Function(BuildContext context) actions;
  final List<AppContextMenuOption<String>> Function(BuildContext context)
  options;
  final List<AppContextMenuAction> Function(BuildContext context)? regionActions;
  final ValueChanged<String?>? onSelected;

  @override
  State<_MenuAnchor> createState() => _MenuAnchorState();
}

class _MenuAnchorState extends State<_MenuAnchor> {
  final FocusNode focusNode = FocusNode(debugLabel: 'menu-anchor');

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = Builder(
      builder: (buttonContext) => Focus(
        focusNode: focusNode,
        child: FilledButton(
          onPressed: () async {
            focusNode.requestFocus();
            final value = await AppContextMenu.select<String>(
              buttonContext,
              globalPosition: AppContextMenu.positionFor(buttonContext),
              options: widget.options(buttonContext),
              headerTitle: 'Zadanie',
              headerSubtitle: 'DEV-1',
            );
            widget.onSelected?.call(value);
          },
          child: const Text('Otwórz menu'),
        ),
      ),
    );

    final regionActions = widget.regionActions;
    if (regionActions == null) return button;
    return AppContextMenuRegion(
      actionsBuilder: regionActions,
      headerTitle: 'Akcje wiersza',
      child: SizedBox(width: 240, height: 40, child: button),
    );
  }
}

List<AppContextMenuOption<String>> _options() => const [
  AppContextMenuOption(
    value: 'open',
    label: 'Otwórz',
    icon: Icons.open_in_new,
    sectionTitle: 'Nawigacja',
    shortcutLabel: 'Enter',
  ),
  AppContextMenuOption(
    value: 'pin',
    label: 'Przypnij',
    icon: Icons.push_pin_outlined,
    selected: true,
  ),
  AppContextMenuOption(
    value: 'locked',
    label: 'Zablokowane',
    enabled: false,
  ),
  AppContextMenuOption(
    value: 'delete',
    label: 'Usuń',
    icon: Icons.delete_outline,
    isDestructive: true,
    sectionTitle: 'Strefa ryzyka',
    separatorBefore: true,
  ),
];

void main() {
  testWidgets('pokazuje jedną powierzchnię z sekcjami i skrótami', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(_MenuAnchor(actions: (_) => const [], options: (_) => _options())),
    );

    await tester.tap(find.text('Otwórz menu'));
    await tester.pumpAndSettle();

    expect(find.text('Zadanie'), findsOneWidget);
    expect(find.text('DEV-1'), findsOneWidget);
    expect(find.text('NAWIGACJA'), findsOneWidget);
    expect(find.text('STREFA RYZYKA'), findsOneWidget);
    expect(find.text('Enter'), findsOneWidget);
    expect(find.text('Otwórz'), findsOneWidget);
    expect(find.byIcon(Icons.push_pin_outlined), findsOneWidget);
  });

  testWidgets('wybór pozycji zwraca wartość i zamyka menu', (tester) async {
    String? selected = 'brak';
    await tester.pumpWidget(
      _harness(
        _MenuAnchor(
          actions: (_) => const [],
          options: (_) => _options(),
          onSelected: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.text('Otwórz menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Przypnij'));
    await tester.pumpAndSettle();

    expect(selected, 'pin');
    expect(find.text('Przypnij'), findsNothing);
  });

  testWidgets('pozycja wyłączona nie reaguje na klik', (tester) async {
    String? selected = 'brak';
    await tester.pumpWidget(
      _harness(
        _MenuAnchor(
          actions: (_) => const [],
          options: (_) => _options(),
          onSelected: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.text('Otwórz menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zablokowane'));
    await tester.pumpAndSettle();

    expect(selected, 'brak');
    expect(find.text('Zablokowane'), findsOneWidget);
  });

  testWidgets('akcja destrukcyjna używa koloru błędu z tokenów', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(_MenuAnchor(actions: (_) => const [], options: (_) => _options())),
    );

    await tester.tap(find.text('Otwórz menu'));
    await tester.pumpAndSettle();

    final theme = MaterialTheme.crm().light();
    final label = tester.widget<Text>(find.text('Usuń'));
    expect(label.style?.color, theme.colorScheme.error);
  });

  testWidgets('klawiatura: strzałki, Enter, Home i End wybierają pozycję', (
    tester,
  ) async {
    String? selected = 'brak';
    Future<void> openMenu() async {
      await tester.tap(find.text('Otwórz menu'));
      await tester.pumpAndSettle();
      expect(find.text('Otwórz'), findsOneWidget);
    }

    await tester.pumpWidget(
      _harness(
        _MenuAnchor(
          actions: (_) => const [],
          options: (_) => _options(),
          onSelected: (value) => selected = value,
        ),
      ),
    );

    // Bez ruchu klawiszy Enter wybiera pierwszą dostępną pozycję.
    await openMenu();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(selected, 'open');

    // Strzałka w dół przechodzi na drugą pozycję.
    await openMenu();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(selected, 'pin');

    // Strzałka w górę z pierwszej pozycji zawija na ostatnią dostępną.
    await openMenu();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(selected, 'delete');

    // End i Home przenoszą wyróżnienie na krańce listy dostępnych pozycji.
    await openMenu();
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(selected, 'open');
  });

  testWidgets('Escape zamyka menu bez wyboru i przywraca focus kotwicy', (
    tester,
  ) async {
    String? selected = 'brak';
    await tester.pumpWidget(
      _harness(
        _MenuAnchor(
          actions: (_) => const [],
          options: (_) => _options(),
          onSelected: (value) => selected = value,
        ),
      ),
    );

    final anchorNode = tester
        .state<_MenuAnchorState>(find.byType(_MenuAnchor))
        .focusNode;
    await tester.pump();

    await tester.tap(find.text('Otwórz menu'));
    await tester.pumpAndSettle();
    expect(find.text('Przypnij'), findsOneWidget);
    // Focus przechodzi do powierzchni menu, a kotwica go oddaje.
    expect(anchorNode.hasFocus, isFalse);
    expect(FocusManager.instance.primaryFocus, isNotNull);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    // Escape zamyka menu bez wartości, więc wywołanie zwraca null, a nie
    // którąkolwiek z pozycji.
    expect(selected, isNull);
    expect(find.text('Przypnij'), findsNothing);
    expect(anchorNode.hasFocus, isTrue);
  });

  testWidgets('prawy klik otwiera ten sam katalog akcji', (tester) async {
    final invoked = <String>[];
    await tester.pumpWidget(
      _harness(
        _MenuAnchor(
          actions: (_) => const [],
          options: (_) => _options(),
          regionActions: (context) => [
            AppContextMenuAction(
              label: 'Otwórz szczegół',
              onTap: (_) => invoked.add('open'),
            ),
            AppContextMenuAction(
              label: 'Archiwizuj',
              icon: Icons.archive_outlined,
              onTap: (_) => invoked.add('archive'),
            ),
          ],
        ),
      ),
    );

    await tester.tapAt(
      tester.getCenter(find.byType(SizedBox).first),
      buttons: kSecondaryButton,
    );
    await tester.pumpAndSettle();

    expect(find.text('Akcje wiersza'), findsOneWidget);
    expect(find.text('Otwórz szczegół'), findsOneWidget);

    await tester.tap(find.text('Archiwizuj'));
    await tester.pumpAndSettle();

    expect(invoked, ['archive']);
  });

  testWidgets('akcje menu wykonują efekt i zamykają powierzchnię', (
    tester,
  ) async {
    final invoked = <String>[];
    await tester.pumpWidget(
      _harness(
        Builder(
          builder: (context) => FilledButton(
            onPressed: () => AppContextMenu.show(
              context,
              globalPosition: AppContextMenu.positionFor(context),
              actions: [
                AppContextMenuAction(
                  label: 'Zmień status',
                  shortcutLabel: 'S',
                  onTap: (_) => invoked.add('status'),
                ),
                AppContextMenuAction(
                  label: 'Zablokowana',
                  enabled: false,
                  onTap: (_) => invoked.add('never'),
                ),
                AppContextMenuAction(
                  label: 'Usuń',
                  isDestructive: true,
                  onTap: (_) => invoked.add('delete'),
                ),
              ],
            ),
            child: const Text('Akcje'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Akcje'));
    await tester.pumpAndSettle();
    expect(find.text('Zmień status'), findsOneWidget);
    expect(find.text('S'), findsOneWidget);

    await tester.tap(find.text('Zmień status'));
    await tester.pumpAndSettle();
    expect(invoked, ['status']);
    expect(find.text('Usuń'), findsNothing);
  });

  testWidgets('menu nie wychodzi poza widok przy krawędzi ekranu', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _harness(
        Align(
          alignment: Alignment.bottomRight,
          child: AppContextMenuRegion(
            actionsBuilder: (context) => [
              AppContextMenuAction(label: 'Ostatnia akcja', onTap: (_) {}),
            ],
            child: const SizedBox(width: 120, height: 32, child: Text('Krawędź')),
          ),
        ),
      ),
    );

    await tester.tapAt(
      tester.getCenter(find.text('Krawędź')),
      buttons: kSecondaryButton,
    );
    await tester.pumpAndSettle();

    final menu = find.text('Ostatnia akcja');
    expect(menu, findsOneWidget);
    final menuRect = tester.getRect(menu);
    expect(menuRect.left, greaterThanOrEqualTo(0));
    expect(menuRect.top, greaterThanOrEqualTo(0));
    expect(menuRect.right, lessThanOrEqualTo(800));
    expect(menuRect.bottom, lessThanOrEqualTo(600));
  });
}

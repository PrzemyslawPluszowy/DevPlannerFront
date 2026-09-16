import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Wspólny shell sekcji modułu z nagłówkiem i obszarem roboczym.
///
/// Pozwala budować ekrany modułów z powtarzalnych klocków:
/// - kartowy nagłówek sekcji,
/// - zestaw akcji zależnych od sekcji,
/// - osobny obszar roboczy na listę, tabelę lub formularz.
class AppModuleSection extends StatelessWidget {
  /// Tworzy wspólny shell sekcji modułu.
  const AppModuleSection({
    required this.title,
    required this.subtitle,
    super.key,
    this.chips = const [],
    this.actions = const [],
    this.child,
    this.headerPadding = const EdgeInsets.symmetric(
      horizontal: Sizes.p16,
      vertical: Sizes.p12,
    ),
  });

  /// Tytuł widoczny w nagłówku sekcji.
  final String title;

  /// Krótki opis sekcji.
  final String subtitle;

  /// Akcje sekcji, np. filtry, odświeżanie, dodawanie rekordu.
  final List<Widget> actions;

  /// Zestaw lekkich akcji chipowych widocznych bezpośrednio pod opisem.
  final List<AppActionChip> chips;

  /// Obszar roboczy sekcji.
  final Widget? child;

  /// Padding nagłówka sekcji.
  final EdgeInsets headerPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        AppSectionCard(
          padding: EdgeInsets.zero,
          child: _AppModuleSectionHeader(
            title: title,
            subtitle: subtitle,
            chips: chips,
            actions: actions,
            contentPadding: headerPadding,
          ),
        ),
        Gaps.h12,
        if (child != null)
          Expanded(child: child!)
        else
          const _AppModuleSectionFallback(),
      ],
    );
  }
}

/// Kartowy nagłówek sekcji modułu.
class _AppModuleSectionHeader extends StatelessWidget {
  /// Tworzy kartowy nagłówek sekcji modułu.
  const _AppModuleSectionHeader({
    required this.title,
    required this.subtitle,
    required this.chips,
    required this.actions,
    required this.contentPadding,
  });

  /// Tytuł sekcji.
  final String title;

  /// Opis sekcji.
  final String subtitle;

  /// Akcje nagłówka.
  final List<Widget> actions;

  /// Chipy szybkich akcji / filtrów.
  final List<AppActionChip> chips;

  /// Padding właściwej treści headera.
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaceRoles = context.surfaceRoles;
    final hasActions = actions.isNotEmpty;
    final hasChips = chips.isNotEmpty;
    final titleBlock = Column(
      crossAxisAlignment: .start,
      children: [
        AppText(
          title,
          style: context.text.titleLarge?.copyWith(
            fontWeight: .w700,
            height: 1.1,
          ),
        ),
        Gaps.h4,
        AppText(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.text.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            height: 1.25,
          ),
        ),
      ],
    );
    final actionsWrap = Wrap(
      alignment: .end,
      crossAxisAlignment: .center,
      spacing: Sizes.p8,
      runSpacing: Sizes.p8,
      children: actions,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        color: surfaceRoles.tintedBackground,
      ),
      child: Padding(
        padding: contentPadding,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final shouldStackActions =
                    hasActions && constraints.maxWidth < 640;

                if (!hasActions) {
                  return titleBlock;
                }

                if (shouldStackActions) {
                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      titleBlock,
                      Gaps.h12,
                      Align(
                        alignment: .centerLeft,
                        child: actionsWrap,
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: titleBlock),
                    Gaps.w16,
                    Flexible(
                      child: Align(
                        alignment: .centerRight,
                        child: actionsWrap,
                      ),
                    ),
                  ],
                );
              },
            ),
            if (hasChips) ...[
              Gaps.h12,
              Wrap(
                spacing: Sizes.p8,
                runSpacing: Sizes.p8,
                children: chips,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Domyślny placeholder sekcji bez danych roboczych.
class _AppModuleSectionFallback extends StatelessWidget {
  /// Tworzy domyślny placeholder sekcji modułu.
  const _AppModuleSectionFallback();

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      tone: AppSectionCardTone.base,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 160),
        alignment: .center,
        child: AppText(
          'Sekcja jest gotowa pod integracje API.',
          textAlign: .center,
          style: context.text.titleMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
            fontWeight: .w600,
          ),
        ),
      ),
    );
  }
}

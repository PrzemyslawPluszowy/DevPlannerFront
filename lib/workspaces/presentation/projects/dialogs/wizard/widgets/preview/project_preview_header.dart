import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_atoms.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_icon_helper.dart';
import 'package:flutter/material.dart';

/// Nagłówek podglądu projektu: ikona w kolorze projektu, nazwa i opis.
///
/// Nagłówek jest wspólny dla wszystkich kroków, więc użytkownik przez cały
/// kreator widzi ten sam projekt i ten sam kolor akcentu.
class ProjectPreviewHeader extends StatelessWidget {
  /// Tworzy nagłówek podglądu.
  const ProjectPreviewHeader({
    required this.title,
    this.description,
    this.iconKey,
    this.colorHex,
    this.badges = const <Widget>[],
    super.key,
  });

  /// Nazwa projektu albo nazwa szablonu, z którego powstanie.
  final String title;

  /// Opis projektu, jeśli został już podany.
  final String? description;

  /// Klucz ikony projektu.
  final String? iconKey;

  /// Kolor projektu w kontrakcie `#RRGGBB`.
  final String? colorHex;

  /// Znaczniki z faktami o projekcie.
  final List<Widget> badges;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = projectPreviewColor(colorHex, colors.primary);
    final description = this.description?.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.16),
                borderRadius: const BorderRadius.all(
                  Radius.circular(Sizes.p12),
                ),
                border: Border.all(color: accent.withValues(alpha: 0.4)),
              ),
              alignment: Alignment.center,
              child: Icon(
                WorkspaceIconHelper.iconFor(iconKey),
                size: 22,
                color: accent,
              ),
            ),
            Gaps.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    Gaps.h4,
                    Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (badges.isNotEmpty) ...[
          Gaps.h12,
          Wrap(spacing: Sizes.p8, runSpacing: Sizes.p4, children: badges),
        ],
      ],
    );
  }
}

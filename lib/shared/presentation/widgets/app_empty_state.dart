import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_control_size.dart';
import 'package:devplanner/shared/presentation/widgets/app_icon.dart';
import 'package:devplanner/shared/presentation/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.title,
    required this.message,
    super.key,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.maxWidth = 420,
    this.compact = false,
  });

  factory AppEmptyState.noData({
    Key? key,
    String title = 'Brak danych',
    String message = 'Nie ma jeszcze zadnych danych do wyswietlenia.',
    Widget? action,
    bool compact = false,
  }) {
    return AppEmptyState(
      key: key,
      title: title,
      message: message,
      action: action,
      compact: compact,
    );
  }

  factory AppEmptyState.noResults({
    Key? key,
    String title = 'Brak wynikow',
    String message = 'Sproboj zmienic filtry albo fraze wyszukiwania.',
    Widget? action,
    bool compact = false,
  }) {
    return AppEmptyState(
      key: key,
      title: title,
      message: message,
      icon: Icons.search_off_rounded,
      action: action,
      compact: compact,
    );
  }

  factory AppEmptyState.error({
    Key? key,
    String title = 'Nie udalo sie zaladowac danych',
    String message = 'Wystapil blad podczas pobierania danych.',
    Widget? action,
    bool compact = false,
  }) {
    return AppEmptyState(
      key: key,
      title: title,
      message: message,
      icon: Icons.error_outline_rounded,
      action: action,
      compact: compact,
    );
  }

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;
  final double maxWidth;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final padding = compact ? Sizes.p16 : Sizes.p24;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLowest,
            borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
            border: Border.all(color: context.colors.outlineVariant),
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              AppIcon(
                icon,
                tone: AppIconTone.muted,
                size: compact ? AppControlSize.small : AppControlSize.large,
                decorated: true,
              ),
              Gaps.h12,
              AppText(
                title,
                textAlign: .center,
                style: context.text.titleMedium?.copyWith(fontWeight: .w700),
              ),
              Gaps.h8,
              AppText(
                message,
                textAlign: .center,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              if (action != null) ...[Gaps.h16, action!],
            ],
          ),
        ),
      ),
    );
  }
}

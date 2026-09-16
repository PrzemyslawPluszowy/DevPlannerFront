import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_ready_users_search_models.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/shared/users_search/inventory_users_search_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Pole osoby z podpowiedziami uzytkownikow i mozliwoscia wolnego wpisu.
class InventoryPersonSuggestionField extends StatelessWidget {
  /// Tworzy pole podpowiedzi dla osoby odpowiedzialnej.
  const InventoryPersonSuggestionField({
    required this.repository,
    required this.controller,
    required this.enabled,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
    super.key,
  });

  /// Repozytorium wyszukiwarki uzytkownikow.
  final UsersRepository repository;

  /// Kontroler pola tekstowego i wyszukiwarki.
  final SearchController controller;

  /// Czy pole jest aktywne.
  final bool enabled;

  /// Etykieta pola.
  final String labelText;

  /// Tekst podpowiedzi dla pola.
  final String hintText;

  /// Callback wywolywany po zmianie wartosci pola.
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.text.labelSmall?.copyWith(
      color: context.colors.onSurfaceVariant,
      fontWeight: .w600,
      height: 1,
    );

    return BlocProvider(
      create: (context) => InventoryUsersSearchCubit(repository: repository),
      child: BlocBuilder<InventoryUsersSearchCubit, InventoryUsersSearchState>(
        builder: (context, state) {
          final cubit = context.read<InventoryUsersSearchCubit>();
          final options = state.results
              .take(10)
              .map(
                (user) => AppSearchDropdownOption<GetReadyUsersSearchItem>(
                  value: user,
                  label: user.displayName,
                  subtitle: _personSuggestionSubtitle(user),
                  icon: Icons.person_outline_rounded,
                  keywords: [
                    user.displayName,
                    ?user.firnam,
                    ?user.lasnam,
                    ?user.usrnam,
                    ?user.eMail,
                    ?user.usrsym,
                    ?user.login,
                  ],
                ),
              )
              .toList(growable: false);

          return Column(
            crossAxisAlignment: .start,
            children: [
              AppText(labelText, style: labelStyle),
              Gaps.h4,
              Focus(
                onKeyEvent: enabled
                    ? (_, event) {
                        if (event is! KeyDownEvent ||
                            event.logicalKey != LogicalKeyboardKey.enter) {
                          return KeyEventResult.ignored;
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                        onChanged();
                        cubit.clear();
                        return KeyEventResult.handled;
                      }
                    : null,
                child: IgnorePointer(
                  ignoring: !enabled,
                  child: Opacity(
                    opacity: enabled ? 1 : .6,
                    child: AppSearchDropdown<GetReadyUsersSearchItem>(
                      searchController: controller,
                      hintText: hintText,
                      options: options,
                      noResultsText: switch (state) {
                        InventoryUsersSearchError(:final message) => message,
                        InventoryUsersSearchLoading() =>
                          context.l10n.inventorySearching,
                        _ when controller.text.trim().length < 2 =>
                          context.l10n.inventoryTypeMinTwoChars,
                        _ => 'Po Enter zostanie wpisana nowa osoba',
                      },
                      onChanged: (value) {
                        cubit.onQueryChanged(value);
                        onChanged();
                      },
                      onSelected: (option) {
                        onChanged();
                        cubit.clear();
                      },
                      isLoading: state is InventoryUsersSearchLoading,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String? _personSuggestionSubtitle(GetReadyUsersSearchItem user) {
    final parts = <String>[];
    if (user.login case final login? when login.trim().isNotEmpty) {
      parts.add(login.trim());
    }
    if (user.usrsym case final symbol? when symbol.trim().isNotEmpty) {
      parts.add(symbol.trim());
    }
    return switch (parts) {
      [] => null,
      _ => parts.join(' • '),
    };
  }
}

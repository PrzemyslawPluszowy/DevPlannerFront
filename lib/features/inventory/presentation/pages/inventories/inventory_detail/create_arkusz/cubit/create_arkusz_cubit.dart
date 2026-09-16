import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/create_arkusz/cubit/create_arkusz_state.dart';

/// Cubit obslugujacy tworzenie nowego arkusza dla inwentaryzacji.
class CreateArkuszCubit extends Cubit<CreateArkuszState> {
  /// Tworzy cubit procesu tworzenia arkusza.
  CreateArkuszCubit({
    required this._inventoriesRepository,
    required this._locationsRepository,
  }) : super(const CreateArkuszLoading());

  final InventoriesRepository _inventoriesRepository;
  final LocationsRepository _locationsRepository;

  /// Laduje miejsca dla wskazanej firmy.
  Future<void> initialize({int? firmaId}) async {
    emit(const CreateArkuszLoading());
    final scopedResult = await _locationsRepository.fetchLocations(
      firma: firmaId,
    );

    final scopedData = scopedResult.fold<GetMiejscaResponseData?>(
      (error) {
        emit(CreateArkuszLoadError(message: error.message));
        return null;
      },
      (data) => data,
    );
    if (scopedData == null) {
      return;
    }

    final scopedItems = switch (firmaId) {
      final int selectedFirmaId =>
        scopedData.items
            .where((location) => location.idFirmy == selectedFirmaId)
            .toList(growable: false),
      null => scopedData.items,
    };

    final sorted = List<GetMiejscaItem>.from(scopedItems)
      ..sort((a, b) {
        final left = (a.nazwa ?? '').trim().toLowerCase();
        final right = (b.nazwa ?? '').trim().toLowerCase();
        return left.compareTo(right);
      });
    emit(
      CreateArkuszReady(
        locations: sorted,
        selectedLocationId: null,
        numerRaw: '',
        komisjaRaw: '',
        submitError: null,
        isSubmitting: false,
      ),
    );
  }

  /// Ustawia wybrane miejsce formularza.
  void selectLocation(int? locationId) {
    final current = state;
    if (current case CreateArkuszReady()) {
      emit(
        current.copyWith(
          selectedLocationId: locationId,
          selectedLocationIdSet: true,
          submitErrorSet: true,
        ),
      );
    }
  }

  /// Aktualizuje surowa wartosc pola komisji.
  void updateKomisjaRaw(String value) {
    final current = state;
    if (current case CreateArkuszReady()) {
      emit(
        current.copyWith(
          komisjaRaw: value,
          submitErrorSet: true,
        ),
      );
    }
  }

  /// Aktualizuje surowa wartosc pola numeru.
  void updateNumerRaw(String value) {
    final current = state;
    if (current case CreateArkuszReady()) {
      emit(
        current.copyWith(
          numerRaw: value,
          submitErrorSet: true,
        ),
      );
    }
  }

  /// Ustawia komunikat bledu zapisu/walidacji formularza.
  void setSubmitError(String? message) {
    final current = state;
    if (current case CreateArkuszReady()) {
      emit(current.copyWith(submitError: message, submitErrorSet: true));
    }
  }

  /// Wysyla zadanie utworzenia arkusza.
  Future<String?> submit({
    required int inventoryId,
    required String? scope,
    required List<int>? komisja,
  }) async {
    final current = state;
    if (current is! CreateArkuszReady || current.isSubmitting) {
      return null;
    }

    if (current.selectedLocationId == null) {
      const message = 'Wybierz miejsce w drzewie przed utworzeniem arkusza.';
      emit(
        current.copyWith(
          submitError: message,
          submitErrorSet: true,
        ),
      );
      return message;
    }

    emit(
      current.copyWith(
        isSubmitting: true,
        submitErrorSet: true,
      ),
    );
    GetMiejscaItem? selectedLocation;
    for (final location in current.locations) {
      if (location.id == current.selectedLocationId) {
        selectedLocation = location;
        break;
      }
    }
    final selected = selectedLocation;
    final selectedFirmaId = selected?.idFirmy;
    final selectedBaza = selected?.baza?.trim();
    if (selected == null ||
        selectedFirmaId == null ||
        selectedFirmaId <= 0 ||
        selectedBaza == null ||
        selectedBaza.isEmpty) {
      const message =
          'Wybrane miejsce ma niepelne dane firmy/bazy. Odswiez liste miejsc i sprobuj ponownie.';
      emit(
        current.copyWith(
          isSubmitting: false,
          submitError: message,
          submitErrorSet: true,
        ),
      );
      return message;
    }

    final result = await _inventoriesRepository.createArkusz(
      inventoryId: inventoryId,
      query: PostArkuszQuery(
        idMiejsca: selected.idMiejsca,
        idFirmy: selectedFirmaId,
        baza: selectedBaza,
        // Ignorujemy przekazany `scope`, bo UI ma dzialac jak Delphi:
        // arkusz obejmuje tylko wybrane miejsce, bez automatycznego subtree.
        scope: 'node',
        numer: switch (current.numerRaw.trim()) {
          final String value when value.isNotEmpty => value,
          _ => null,
        },
        komisja: komisja,
      ),
    );
    return result.fold(
      (error) {
        emit(
          current.copyWith(
            isSubmitting: false,
            submitError: error.message,
            submitErrorSet: true,
          ),
        );
        return error.message;
      },
      (response) {
        emit(CreateArkuszSuccess(response: response));
        return null;
      },
    );
  }
}

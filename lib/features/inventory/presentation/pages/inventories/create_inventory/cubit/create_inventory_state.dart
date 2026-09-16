import 'package:equatable/equatable.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';

/// Bazowy stan tworzenia nowej inwentaryzacji.
sealed class CreateInventoryState extends Equatable {
  /// Tworzy bazowy stan tworzenia inwentaryzacji.
  const CreateInventoryState();
}

final class CreateInventoryLoading extends CreateInventoryState {
  /// Tworzy stan ladowania danych do tworzenia inwentaryzacji.
  const CreateInventoryLoading();

  @override
  List<Object?> get props => [];
}

final class CreateInventoryLoaded extends CreateInventoryState {
  /// Tworzy stan gotowosci do tworzenia inwentaryzacji z zaladowanymi danymi.
  const CreateInventoryLoaded({
    required this.companies,
    required this.selectedFirmaId,
    required this.isSending,
    this.companiesError,
    this.submitError,
  });

  final List<GetFirmyItem> companies;
  final int? selectedFirmaId;
  final bool isSending;
  final String? companiesError;
  final String? submitError;

  @override
  List<Object?> get props => [
    companies,
    selectedFirmaId,
    isSending,
    companiesError,
    submitError,
  ];

  //copyWith dla latwej aktualizacji stanu
  CreateInventoryLoaded copyWith({
    List<GetFirmyItem>? companies,
    int? selectedFirmaId,
    bool? isSending,
    String? companiesError,
    String? submitError,
    bool submitErrorSet = false,
  }) {
    return CreateInventoryLoaded(
      companies: companies ?? this.companies,
      selectedFirmaId: selectedFirmaId ?? this.selectedFirmaId,
      isSending: isSending ?? this.isSending,
      companiesError: companiesError ?? this.companiesError,
      submitError: submitErrorSet ? submitError : this.submitError,
    );
  }
}

final class CreateInventoryError extends CreateInventoryState {
  /// Tworzy stan bledu podczas tworzenia inwentaryzacji.
  const CreateInventoryError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class CreateInventorySended extends CreateInventoryState {
  const CreateInventorySended();

  @override
  List<Object?> get props => [];
}

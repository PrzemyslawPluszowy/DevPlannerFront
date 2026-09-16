import 'package:equatable/equatable.dart';

/// Stan modalu usuwania firmy.
sealed class DeleteCompanyState extends Equatable {
  const DeleteCompanyState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy modalu usuwania.
final class DeleteCompanyInitial extends DeleteCompanyState {
  const DeleteCompanyInitial();
}

/// Stan wykonywania usuwania firmy.
final class DeleteCompanySubmitting extends DeleteCompanyState {
  const DeleteCompanySubmitting();
}

/// Stan poprawnego usunięcia firmy.
final class DeleteCompanySuccess extends DeleteCompanyState {
  const DeleteCompanySuccess();
}

/// Stan błędu usuwania firmy.
final class DeleteCompanyError extends DeleteCompanyState {
  const DeleteCompanyError({required this.message});

  /// Komunikat błędu zwrócony do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}

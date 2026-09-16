import 'package:equatable/equatable.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';

/// Stan listy firm.
sealed class CompaniesState extends Equatable {
  const CompaniesState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy.
final class CompaniesInitial extends CompaniesState {
  const CompaniesInitial();
}

/// Stan ładowania danych.
final class CompaniesLoading extends CompaniesState {
  const CompaniesLoading();
}

/// Stan pomyślnego pobrania danych.
final class CompaniesSuccess extends CompaniesState {
  const CompaniesSuccess({required this.companies});

  /// Lista firm pobrana z API.
  final List<GetFirmyItem> companies;

  @override
  List<Object?> get props => [companies];
}

/// Stan błędu pobierania danych.
final class CompaniesError extends CompaniesState {
  const CompaniesError({required this.message});

  /// Komunikat o błędzie.
  final String message;

  @override
  List<Object?> get props => [message];
}

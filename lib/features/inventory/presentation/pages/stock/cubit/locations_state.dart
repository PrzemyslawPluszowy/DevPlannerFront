import 'package:equatable/equatable.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';

/// Stan listy miejsc.
sealed class LocationsState extends Equatable {
  const LocationsState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy.
final class LocationsInitial extends LocationsState {
  const LocationsInitial();
}

/// Stan ładowania danych.
final class LocationsLoading extends LocationsState {
  const LocationsLoading();
}

/// Stan pomyślnego pobrania danych.
final class LocationsSuccess extends LocationsState {
  const LocationsSuccess({required this.data});

  /// Dane odpowiedzi z API (lista miejsc).
  final GetMiejscaResponseData data;

  @override
  List<Object?> get props => [data];
}

/// Stan błędu pobierania danych.
final class LocationsError extends LocationsState {
  const LocationsError({required this.message});

  /// Komunikat o błędzie.
  final String message;

  @override
  List<Object?> get props => [message];
}

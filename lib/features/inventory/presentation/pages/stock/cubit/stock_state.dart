import 'package:equatable/equatable.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';

/// Baza stanów dla sekcji "Stan ŚT".
sealed class StockState extends Equatable {
  const StockState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy przed ładowaniem.
final class StockInitial extends StockState {
  const StockInitial();
}

/// Stan aktywnego pobierania danych.
final class StockLoading extends StockState {
  const StockLoading();
}

/// Stan sukcesu z listą rekordów ŚT.
final class StockSuccess extends StockState {
  const StockSuccess({required this.data});

  final GetStanStResponseData data;

  @override
  List<Object?> get props => [data];
}

/// Stan błędu podczas pobierania.
final class StockError extends StockState {
  const StockError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

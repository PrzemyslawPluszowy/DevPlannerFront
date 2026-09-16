import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_models.freezed.dart';
part 'portfolio_models.g.dart';

/// Payload utworzenia portfolio.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreatePortfolioPayload with _$CreatePortfolioPayload {
  /// Tworzy dane zgodne z `CreatePortfolioRequest`.
  const factory CreatePortfolioPayload({
    /// Nazwa portfolio.
    required String name,

    /// Opcjonalny opis portfolio.
    String? description,
  }) = _CreatePortfolioPayload;

  /// Odtwarza payload z JSON.
  factory CreatePortfolioPayload.fromJson(Map<String, dynamic> json) =>
      _$CreatePortfolioPayloadFromJson(json);
}

/// Payload aktualizacji portfolio.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdatePortfolioPayload with _$UpdatePortfolioPayload {
  /// Tworzy dane zgodne z `UpdatePortfolioRequest`.
  const factory UpdatePortfolioPayload({
    /// Nowa nazwa portfolio.
    required String name,

    /// Nowy opis portfolio albo null.
    String? description,
  }) = _UpdatePortfolioPayload;

  /// Odtwarza payload z JSON.
  factory UpdatePortfolioPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdatePortfolioPayloadFromJson(json);
}

/// Payload przypisania projektów do portfolio.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AddPortfolioProjectsPayload with _$AddPortfolioProjectsPayload {
  /// Tworzy dane zgodne z `AddPortfolioProjectsRequest`.
  const factory AddPortfolioProjectsPayload({
    /// UUID-y aktywnych projektów należących do tego samego workspace.
    required List<String> projectIds,
  }) = _AddPortfolioProjectsPayload;

  /// Odtwarza payload z JSON.
  factory AddPortfolioProjectsPayload.fromJson(Map<String, dynamic> json) =>
      _$AddPortfolioProjectsPayloadFromJson(json);
}

/// Odpowiedź z danymi portfolio.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class PortfolioResponse with _$PortfolioResponse {
  /// Tworzy odpowiedź zgodną z `PortfolioResponse`.
  const factory PortfolioResponse({
    /// UUID portfolio.
    required String id,

    /// UUID workspace.
    required String workspaceId,

    /// UUID twórcy portfolio.
    required String createdByCoreUserId,

    /// Nazwa portfolio.
    required String name,

    /// Opis albo null.
    String? description,

    /// Procent wykonania.
    required double progress,

    /// UUID-y projektów należących do portfolio.
    required List<String> projectIds,

    /// Czas utworzenia.
    required DateTime createdAtUtc,

    /// Czas aktualizacji.
    required DateTime updatedAtUtc,

    /// Wersja optimistic concurrency.
    required int version,
  }) = _PortfolioResponse;

  /// Odtwarza portfolio z JSON.
  factory PortfolioResponse.fromJson(Map<String, dynamic> json) =>
      _$PortfolioResponseFromJson(json);
}

/// Zestaw agregatów dashboardu portfolio.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class PortfolioDashboardResponse with _$PortfolioDashboardResponse {
  /// Tworzy odpowiedź zgodną z `PortfolioDashboardResponse`.
  const factory PortfolioDashboardResponse({
    /// UUID portfolio.
    required String portfolioId,

    /// Liczba projektów.
    required int projectCount,

    /// Procent wykonania.
    required double progress,

    /// Liczba otwartych zadań.
    required int openTaskCount,

    /// Liczba zakończonych zadań.
    required int doneTaskCount,

    /// Liczba zadań po terminie.
    required int overdueTaskCount,

    /// Liczba aktywnych milestone’ów.
    required int activeMilestoneCount,

    /// Czas obliczenia agregatów.
    required DateTime calculatedAtUtc,
  }) = _PortfolioDashboardResponse;

  /// Odtwarza dashboard portfolio z JSON.
  factory PortfolioDashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$PortfolioDashboardResponseFromJson(json);
}

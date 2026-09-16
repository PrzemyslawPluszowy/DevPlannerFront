import 'package:flutter/material.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_report_models.dart';

/// Definicja raportu inwentaryzacji używana przez UI.
class InventoryReportDefinition {
  /// Tworzy definicję raportu.
  const InventoryReportDefinition({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.documentTitle,
    this.isInternal = false,
    this.supportsUwagi = false,
  });

  /// Typ raportu backendowego.
  final InwentaryzacjaReportType type;

  /// Tytuł widoczny dla użytkownika.
  final String title;

  /// Opis raportu zgodny z logiką backendu.
  final String description;

  /// Ikona raportu.
  final IconData icon;

  /// Docelowy tytuł dokumentu PDF dla v2.
  final String documentTitle;

  /// Czy raport ma charakter wewnętrzny i powinien być wyróżniony ostrzeżeniem.
  final bool isInternal;

  /// Czy raport może opcjonalnie pokazywać kolumnę uwag.
  final bool supportsUwagi;

  /// Czy raport udostępnia dodatkowy protokół kasacji.
  bool get supportsDisposalProtocol =>
      type == InwentaryzacjaReportType.elementyDoLikwidacji;
}

/// Stałe definicje raportów dostępnych w v1.
abstract final class InventoryReportDefinitions {
  /// Raporty składające się na pełny pakiet zgodny z dawnym Delphi.
  static const List<InventoryReportDefinition> fullBundle = [
    braki,
    nadwyzki,
    kompensaty,
    kasacje,
    brakiNieskompensowane,
    nadwyzkiNieskompensowane,
  ];

  /// Zbiorcze zestawienie wszystkich pozycji z arkuszy spisu.
  static const ogolnyStanSpisu = InventoryReportDefinition(
    type: InwentaryzacjaReportType.ogolnyStanSpisu,
    title: 'Ogólny stan spisu',
    description:
        'Pokazuje wszystkie elementy ujęte w arkuszach tej inwentaryzacji, z pominięciem pozycji oznaczonych jako znalezione w innych firmach.',
    icon: Icons.inventory_2_outlined,
    documentTitle: 'Ogólny stan spisu',
    supportsUwagi: true,
  );

  /// Wszystkie braki wykazane podczas spisu.
  static const braki = InventoryReportDefinition(
    type: InwentaryzacjaReportType.braki,
    title: 'Braki inwentaryzacyjne',
    description:
        'Pokazuje wszystkie elementy, których nie odnaleziono podczas spisu. Raport obejmuje zarówno zwykłe braki, jak i te, które później mogły zostać skompensowane.',
    icon: Icons.indeterminate_check_box_outlined,
    documentTitle: 'Braki inwentaryzacyjne',
    supportsUwagi: true,
  );

  /// Nadwyżki raportowalne.
  static const nadwyzki = InventoryReportDefinition(
    type: InwentaryzacjaReportType.nadwyzki,
    title: 'Nadwyżki inwentaryzacyjne',
    description:
        'Pokazuje elementy uznane podczas spisu za nadwyżkę, z uwzględnieniem pozycji oznaczonych jako nowe i zakupione w trakcie inwentaryzacji, ale bez rzeczy znalezionych w innych firmach.',
    icon: Icons.add_chart_rounded,
    documentTitle: 'Nadwyżki inwentaryzacyjne',
    supportsUwagi: true,
  );

  /// Braki i nadwyżki sparowane przez backend.
  static const kompensaty = InventoryReportDefinition(
    type: InwentaryzacjaReportType.kompensaty,
    title: 'Kompensaty',
    description:
        'Pokazuje pary elementów, w których jeden wyszedł jako brak, a drugi jako nadwyżka tego samego środka trwałego w tej samej firmie. Dzięki temu widać, że rzecz nie zniknęła, tylko została znaleziona gdzie indziej.',
    icon: Icons.compare_arrows_rounded,
    documentTitle: 'Kompensaty',
  );

  /// Elementy przeznaczone do likwidacji.
  static const kasacje = InventoryReportDefinition(
    type: InwentaryzacjaReportType.elementyDoLikwidacji,
    title: 'Kasacje',
    description:
        'Pokazuje elementy oznaczone podczas spisu do likwidacji. To lista pozycji przeznaczonych do dalszej decyzji lub przygotowania dokumentu kasacyjnego.',
    icon: Icons.delete_sweep_outlined,
    documentTitle: 'Kasacje',
    supportsUwagi: true,
  );

  /// Braki bez kompensacji.
  static const brakiNieskompensowane = InventoryReportDefinition(
    type: InwentaryzacjaReportType.brakiNieskompensowane,
    title: 'Braki inwentaryzacyjne nieskompensowane',
    description:
        'Pokazuje braki, dla których nigdzie w tej inwentaryzacji nie znaleziono pasującej nadwyżki. Trafiają tu też elementy oznaczone jako sprzedane w trakcie inwentaryzacji.',
    icon: Icons.remove_circle_outline_rounded,
    documentTitle: 'Braki inwentaryzacyjne nieskompensowane',
    supportsUwagi: true,
  );

  /// Nadwyżki bez kompensacji.
  static const nadwyzkiNieskompensowane = InventoryReportDefinition(
    type: InwentaryzacjaReportType.nadwyzkiNieskompensowane,
    title: 'Nadwyżki inwentaryzacyjne nieskompensowane',
    description:
        'Pokazuje nadwyżki, dla których nie ma pasującego braku po drugiej stronie. Trafiają tu też elementy oznaczone jako nowe oraz zakupione w trakcie inwentaryzacji.',
    icon: Icons.playlist_add_check_circle_outlined,
    documentTitle: 'Nadwyżki inwentaryzacyjne nieskompensowane',
    supportsUwagi: true,
  );

  /// Elementy znalezione poza firmami z zakresu.
  static const znalezioneWInnejFirmie = InventoryReportDefinition(
    type: InwentaryzacjaReportType.znalezioneWInnejFirmie,
    title: 'Elementy znalezione w innych firmach',
    description:
        'Pokazuje elementy znalezione podczas spisu, ale przypisane do firmy spoza zakresu tej inwentaryzacji. To raport pomocniczy, do użytku wewnętrznego.',
    icon: Icons.domain_add_rounded,
    documentTitle: 'Elementy znalezione w innych firmach',
    isInternal: true,
    supportsUwagi: true,
  );

  /// Lista raportów udostępnionych w v1.
  static const List<InventoryReportDefinition> v1 = [
    ogolnyStanSpisu,
    braki,
    nadwyzki,
    kompensaty,
    kasacje,
    brakiNieskompensowane,
    nadwyzkiNieskompensowane,
    znalezioneWInnejFirmie,
  ];
}

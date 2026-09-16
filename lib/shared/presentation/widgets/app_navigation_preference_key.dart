import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/auth/auth_repository.dart';

/// Buduje klucz lokalnej preferencji panelu dla konkretnego konta.
///
/// Ustawienia są przechowywane lokalnie na urządzeniu, ale prefiks konta
/// zapobiega przenoszeniu stanu panelu pomiędzy użytkownikami korzystającymi
/// z tej samej przeglądarki lub komputera.
String appNavigationPreferenceKey(BuildContext context, String panelId) {
  final user = context.read<AuthRepository>().currentUser;
  final accountId = user?.coreUserId?.trim().isNotEmpty == true
      ? user!.coreUserId!.trim()
      : user?.userId.toString() ?? 'anonymous';
  return '$panelId:$accountId';
}

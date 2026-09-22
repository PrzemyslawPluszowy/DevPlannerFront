import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/chat_global_notification_settings_section.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_global_notification_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wejście do ustawień komunikatora z panelu.
///
/// Modal wydaje własny cubit globalnych kanałów powiadomień, więc panel nie
/// zależy od tego, co przypadkiem jest w kontekście trasy, a zapis nie
/// odświeża niepowiązanych powierzchni. Preferencje całej aplikacji zostają w
/// modalu powiadomień — tutaj jest wyłącznie komunikator.
abstract final class ChatGlobalSettingsModal {
  /// Otwiera ustawienia komunikatora bez zmiany bieżącej trasy.
  static Future<void> show(
    BuildContext context, {
    required ChatNotificationSettingsRepository repository,
  }) => DevPlannerModalHost.showDialog<void>(
    context,
    builder: (_) => BlocProvider(
      create: (_) {
        final cubit = ChatGlobalNotificationSettingsCubit(repository);
        unawaited(cubit.load());
        return cubit;
      },
      child: const _ChatGlobalSettingsDialog(),
    ),
  );
}

class _ChatGlobalSettingsDialog extends StatelessWidget {
  const _ChatGlobalSettingsDialog();

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.chatPanelGlobalSettingsTitle),
    content: const SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: ChatGlobalNotificationSettingsSection(),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(context.l10n.frameworkClose),
      ),
    ],
  );
}

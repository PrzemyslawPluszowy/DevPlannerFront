import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_state.dart';
import 'package:flutter/material.dart';


/// Tekst walidacji kreatora rozmowy; jedno źródło mapowania kodu na ARB.
class ChatCreationValidationText extends StatelessWidget {
  /// Tworzy komunikat walidacji.
  const ChatCreationValidationText({
    required this.validation,
    this.style,
    super.key,
  });

  final ChatCreationValidation validation;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Text(message(context), style: style),
  );

  /// Zwraca komunikat ARB dla kodu walidacji.
  String message(BuildContext context) => switch (validation) {
    ChatCreationValidation.nameRequired =>
      context.l10n.chatCreationValidationNameRequired,
    ChatCreationValidation.nameTooLong =>
      context.l10n.chatCreationValidationNameTooLong,
    ChatCreationValidation.directRequiresOneParticipant =>
      context.l10n.chatCreationValidationDirectOne,
    ChatCreationValidation.groupRequiresParticipant =>
      context.l10n.chatCreationValidationGroupRequired,
    ChatCreationValidation.groupTooManyParticipants =>
      context.l10n.chatCreationValidationGroupTooMany,
  };
}

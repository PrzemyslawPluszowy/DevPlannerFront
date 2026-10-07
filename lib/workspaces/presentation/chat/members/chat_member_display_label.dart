import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:flutter/widgets.dart';

/// Identyfikator techniczny nie zastępuje nazwy osoby w interfejsie.
extension ChatMemberDisplayLabel on ChatMember {
  String displayLabel(BuildContext context) {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final accountLogin = login?.trim();
    if (accountLogin != null && accountLogin.isNotEmpty) return accountLogin;
    return context.l10n.chatMentionUnknownMember;
  }
}

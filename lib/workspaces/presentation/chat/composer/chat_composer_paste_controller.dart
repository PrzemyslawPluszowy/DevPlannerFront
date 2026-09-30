import 'dart:convert';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy_repository.dart';
import 'package:devplanner/workspaces/domain/chat/snippets/chat_snippet_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_state.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_link_policy_cache.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_long_paste_decision.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Koordynuje długie wklejenie, konwersję TXT i cleanup uploadu szkicu.
final class ChatComposerPasteController extends ChangeNotifier {
  ChatComposerPasteController({
    required this.contextProvider,
    required this.mountedProvider,
    required this.conversationId,
    required this.cubit,
    required this.attachmentCoordinator,
    required this.insertText,
  });

  static const String snippetFileName = 'chat-snippet.txt';

  final BuildContext Function() contextProvider;
  final bool Function() mountedProvider;
  final String conversationId;
  final ChatComposerCubit cubit;
  final ChatAttachmentComposerCoordinatorCubit? Function()
  attachmentCoordinator;
  final void Function(String text) insertText;

  final ChatLinkPolicyCache _policyCache = ChatLinkPolicyCache();
  ChatLongPasteAssessment? pendingPaste;
  String? pendingPasteText;
  String? pendingPasteNotice;
  String? pendingPasteFailure;
  bool isPreparing = false;
  bool _isReading = false;
  bool _forceRawFile = false;
  String? _attachmentLocalId;
  bool _disposed = false;

  BuildContext get _context => contextProvider();
  bool get _mounted => !_disposed && mountedProvider();

  void _changed() {
    if (!_disposed && _mounted) notifyListeners();
  }

  Future<void> handlePaste() async {
    if (pendingPaste != null || isPreparing || _isReading) return;
    _isReading = true;
    try {
      final context = _context;
      final l10n = context.l10n;
      final repository = context.read<ChatLinkPolicyRepository?>();
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final text = data?.text;
      if (!_mounted || !context.mounted || text == null || text.isEmpty) {
        return;
      }
      final policy = await _policyCache.load(repository);
      if (!_mounted || !context.mounted) return;
      if (repository != null && !_policyCache.isLoaded) {
        AppToast.show(
          context,
          message: l10n.chatLongPastePolicyLoadFailed,
          tone: AppToastTone.error,
        );
        return;
      }
      final assessment = ChatLongPasteDecision.assess(
        text: text,
        policy: policy,
      );
      if (assessment.kind == ChatLongPasteKind.text) {
        insertText(text);
        return;
      }
      pendingPasteText = text;
      pendingPaste = assessment;
      pendingPasteNotice = null;
      pendingPasteFailure = null;
      _changed();
      await sendPendingAsFile();
    } finally {
      _isReading = false;
    }
  }

  void sendDraftAsFile(String text) {
    if (pendingPaste != null ||
        isPreparing ||
        _isReading ||
        text.trim().isEmpty) {
      return;
    }
    final assessment = ChatLongPasteDecision.assess(
      text: text,
      policy: _policyCache.value,
    );
    pendingPasteText = text;
    pendingPaste = ChatLongPasteAssessment(
      kind: ChatLongPasteKind.file,
      characters: assessment.characters,
      byteLength: assessment.byteLength,
      previewLines: assessment.previewLines,
    );
    pendingPasteNotice = null;
    pendingPasteFailure = null;
    _forceRawFile = true;
    _changed();
  }

  Future<void> keepAsText() async {
    final l10n = _context.l10n;
    final text = pendingPasteText;
    if (text == null || pendingPaste?.kind == ChatLongPasteKind.overLimit) {
      return;
    }
    final localId = _attachmentLocalId;
    final coordinator = attachmentCoordinator();
    if (localId != null) {
      if (coordinator == null) {
        pendingPasteFailure = l10n.chatLongPastePrepareFailed;
        _changed();
        return;
      }
      isPreparing = true;
      pendingPasteFailure = null;
      _changed();
      try {
        await coordinator.remove(conversationId, localId);
      } on Object {
        if (!_mounted) return;
        isPreparing = false;
        pendingPasteFailure = l10n.chatLongPastePrepareFailed;
        _changed();
        return;
      }
      if (!_mounted) return;
    }
    _clear();
    insertText(text);
  }

  Future<void> discard() async {
    final l10n = _context.l10n;
    final localId = _attachmentLocalId;
    final coordinator = attachmentCoordinator();
    if (localId == null || coordinator == null) {
      _clear();
      return;
    }
    isPreparing = true;
    pendingPasteFailure = null;
    _changed();
    try {
      await coordinator.remove(conversationId, localId);
    } on Object {
      if (!_mounted) return;
      isPreparing = false;
      pendingPasteFailure = l10n.chatLongPastePrepareFailed;
      _changed();
      return;
    }
    if (_mounted) _clear();
  }

  void _clear() {
    pendingPasteText = null;
    pendingPaste = null;
    pendingPasteNotice = null;
    pendingPasteFailure = null;
    _forceRawFile = false;
    _attachmentLocalId = null;
    isPreparing = false;
    _changed();
  }

  Future<void> sendPendingAsFile() async {
    final l10n = _context.l10n;
    try {
      await _preparePendingAsFile();
    } on Object {
      if (!_mounted) return;
      isPreparing = false;
      pendingPasteFailure = l10n.chatLongPastePrepareFailed;
      _changed();
    }
  }

  Future<void> _preparePendingAsFile() async {
    final l10n = _context.l10n;
    final text = pendingPasteText;
    final repository = _context.read<ChatSnippetRepository?>();
    final coordinator = attachmentCoordinator();
    final forceRaw = _forceRawFile;
    if (text == null) return;
    if (coordinator == null) {
      pendingPasteFailure = l10n.chatLongPastePrepareFailed;
      _changed();
      return;
    }
    isPreparing = true;
    pendingPasteFailure = null;
    _changed();
    final overLimit = pendingPaste?.kind == ChatLongPasteKind.overLimit;
    ChatSnippetPreparation? preparation;
    if (!overLimit && !forceRaw && repository != null) {
      try {
        final result = await repository.prepare(
          conversationId: conversationId,
          text: text,
        );
        if (!_mounted) return;
        preparation = result.fold<ChatSnippetPreparation?>(
          (_) => null,
          (value) =>
              value.content == null || value.content!.isEmpty ? null : value,
        );
      } on Object {
        // Preparation is an optimization. If it fails, preserve all pasted
        // content and let Storage perform the normal file upload.
      }
    }
    final prepared = preparation;
    final content = ChatLongPasteDecision.contentForUpload(
      originalText: text,
      preparation: prepared,
      forceOriginal: forceRaw || overLimit || repository == null,
    );
    final bytes = utf8.encode(content);
    if (bytes.length > coordinator.selectionCubit.limits.maxFileSizeBytes) {
      isPreparing = false;
      pendingPasteFailure = l10n.chatLongPasteAttachmentTooLarge;
      _changed();
      return;
    }
    if (_attachmentLocalId == null) {
      final previousCount = coordinator.selection.attachments.length;
      coordinator.selectInputs(<StorageUploadInput>[
        StorageUploadInput(
          name: preparation?.suggestedFileName ?? snippetFileName,
          size: bytes.length,
          bytes: Uint8List.fromList(bytes),
          mimeType: preparation?.mimeType ?? 'text/plain; charset=utf-8',
        ),
      ]);
      final selection = coordinator.selectionCubit.state;
      if (selection is! ChatAttachmentSelectionReady ||
          selection.attachments.length <= previousCount) {
        isPreparing = false;
        pendingPasteFailure = l10n.chatLongPastePrepareFailed;
        _changed();
        return;
      }
      _attachmentLocalId = selection.attachments.last.localId;
    }
    await coordinator.prepare(conversationId);
    if (!_mounted) return;
    if (coordinator.state is ChatAttachmentComposerCoordinatorReady) {
      isPreparing = false;
      _clear();
      return;
    }
    isPreparing = false;
    pendingPasteFailure = l10n.chatLongPastePrepareFailed;
    _changed();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

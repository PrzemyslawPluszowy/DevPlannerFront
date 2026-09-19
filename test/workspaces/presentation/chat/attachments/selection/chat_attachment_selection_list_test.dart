import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/widgets/chat_attachment_selection_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('prezentuje status lokalnego pliku i pozwala odłączyć wybór', (
    tester,
  ) async {
    final cubit = ChatAttachmentSelectionCubit();
    cubit.selectInputs([const StorageUploadInput(name: 'spec.pdf', size: 1)]);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: const Scaffold(body: ChatAttachmentSelectionList()),
        ),
      ),
    );

    expect(find.text('spec.pdf'), findsOneWidget);
    expect(find.text('Processing'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove attachment'));
    await tester.pump();
    expect(find.text('No attachments selected'), findsOneWidget);
    await cubit.close();
  });
}

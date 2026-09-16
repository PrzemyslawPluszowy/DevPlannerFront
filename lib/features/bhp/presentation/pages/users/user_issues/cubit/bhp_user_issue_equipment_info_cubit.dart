import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issue_equipment_info_state.dart';

/// Cubit modala szczegółów karty wyposażenia z wydania pracownika.
class BhpUserIssueEquipmentInfoCubit
    extends Cubit<BhpUserIssueEquipmentInfoState> {
  /// Tworzy cubit modala szczegółów karty wyposażenia.
  BhpUserIssueEquipmentInfoCubit({
    required this._repository,
  }) : super(const BhpUserIssueEquipmentInfoInitial());

  final BhpEquipmentRepository _repository;

  /// Ładuje szczegóły wskazanej karty wyposażenia.
  Future<void> load(int equipmentId) async {
    emit(const BhpUserIssueEquipmentInfoLoading());

    final result = await _repository.getEquipmentDetails(equipmentId);
    result.fold(
      (error) => emit(BhpUserIssueEquipmentInfoError(message: error.message)),
      (item) => emit(BhpUserIssueEquipmentInfoSuccess(item: item)),
    );
  }
}

import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_duplicates_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

class StockDuplicatesCubit
    extends LoadableCubit<GetStanStDuplicatesResponseData> {
  StockDuplicatesCubit({required this._repository});

  final StockRepository _repository;
  int _requestSequence = 0;

  Future<void> load({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        state is LoadableSuccess<GetStanStDuplicatesResponseData>) {
      return;
    }

    final requestId = ++_requestSequence;
    emitLoading();

    final result = await _repository.fetchStockDuplicates();
    if (isClosed || requestId != _requestSequence) {
      return;
    }

    result.fold(
      (error) => emitError(error.message),
      emitSuccess,
    );
  }

  Future<void> refresh() => load(forceRefresh: true);
}

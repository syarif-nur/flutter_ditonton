import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/usecases/get_tv_detail.dart';
import '../../../../domain/usecases/get_watchlist_status_tv.dart';

part 'detail_tv_event.dart';
part 'detail_tv_state.dart';

class DetailTvBloc extends Bloc<DetailTvEvent, DetailTvState> {
  final GetTvDetail _getTvDetail;
  final GetWatchListStatusTv _getWatchListStatusTv;
  final SaveWatchlistTv _saveWatchListTv;
  final RemoveWatchlistTv _removeWatchlistTv;

  DetailTvBloc(
    this._getTvDetail,
    this._getWatchListStatusTv,
    this._saveWatchListTv,
    this._removeWatchlistTv,
  ) : super(DetailTvInitial()) {
    on<DetailTvFetched>((event, emit) async {
      emit(DetailTvLoading());

      final result = await _getTvDetail.execute(event.id);
      final status = await _getWatchListStatusTv.execute(event.id);

      result.fold(
        (failure) => emit(DetailTvError(failure.message)),
        (data) => emit(DetailTvHasData(data, status)),
      );
    });

    on<AddToWatchlist>((event, emit) async {
      final result = await _saveWatchListTv.execute(event.tvDetail);

      result.fold(
        (failure) => emit(DetailTvError(failure.message)),
        (data) {
          add(DetailTvFetched(event.tvDetail.id));
          emit(const DetailTvMessage('Added to Watchlist'));
        },
      );
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await _removeWatchlistTv.execute(event.tvDetail);

      result.fold(
        (failure) => emit(DetailTvError(failure.message)),
        (data) {
          add(DetailTvFetched(event.tvDetail.id));
          emit(const DetailTvMessage('Removed from Watchlist'));
        },
      );
    });
  }
}

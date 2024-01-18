import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../domain/usecases/get_movie_detail.dart';
import '../../../../domain/usecases/save_watchlist.dart';

part 'detail_movie_event.dart';
part 'detail_movie_state.dart';

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  final GetMovieDetail _getMovieDetail;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  DetailMovieBloc(
    this._getMovieDetail,
    this._getWatchListStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(DetailMovieInitial()) {

    on<DetailMovieFetched>((event, emit) async {
      emit(DetailMovieLoading());

      final result = await _getMovieDetail.execute(event.id);
      final status = await _getWatchListStatus.execute(event.id);

      result.fold(
        (failure) => emit(DetailMovieError(failure.message)),
        (data) => emit(DetailMovieHasData(data, status)),
      );
    });

    on<AddToWatchlist>((event, emit) async {
      final result = await _saveWatchlist.execute(event.movieDetail);

      result.fold(
        (failure) => emit(DetailMovieError(failure.message)),
        (data) {
          add(DetailMovieFetched(event.movieDetail.id));
          emit(const DetailMovieMessage('Added to Watchlist'));
        },
      );
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await _removeWatchlist.execute(event.movieDetail);

      result.fold(
        (failure) => emit(DetailMovieError(failure.message)),
        (data) {
          add(DetailMovieFetched(event.movieDetail.id));
          emit(const DetailMovieMessage('Removed from Watchlist'));
        },
      );
    });
  }
}

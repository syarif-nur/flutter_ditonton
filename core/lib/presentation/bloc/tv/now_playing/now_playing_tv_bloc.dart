import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/usecases/get_now_playing_tv.dart';

part 'now_playing_tv_event.dart';

part 'now_playing_tv_state.dart';

class NowPlayingTvBloc extends Bloc<NowPlayingTvEvent, NowPlayingTvState> {
  final GetNowPlayingTv _getNowPlayingTv;

  NowPlayingTvBloc(this._getNowPlayingTv) : super(NowPlayingTvInitial()) {
    on<NowPlayingTvFetched>((event, emit) async {
      emit(NowPlayingTvLoading());
      final result = await _getNowPlayingTv.execute();

      result.fold(
        (failure) => emit(NowPlayingTvError(failure.message)),
        (data) => emit(NowPlayingTvHasData(data)),
      );
    });
  }
}

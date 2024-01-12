import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/get_now_playing_movies.dart';

part 'now_playing_movie_event.dart';

part 'now_playing_movie_state.dart';

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMovieBloc(
    this._getNowPlayingMovies,
  ) : super(NowPlayingMovieInitial()) {
    on<NowPlayingMovieFetched>((event, emit) async {
      emit(NowPlayingMovieLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold(
            (failure) => emit(NowPlayingMovieError(failure.message)),
            (data) => emit(NowPlayingMovieHasData(data)),
      );
    });
  }
}

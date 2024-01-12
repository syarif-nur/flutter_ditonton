import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/get_movie_recommendations.dart';

part 'recommendation_movie_event.dart';

part 'recommendation_movie_state.dart';

class RecommendationMovieBloc
    extends Bloc<RecommendationMovieEvent, RecommendationMovieState> {
  final GetMovieRecommendations _getMovieRecommendations;

  RecommendationMovieBloc(this._getMovieRecommendations)
      : super(RecommendationMovieInitial()) {
    on<RecommendationMovieFetched>((event, emit) async {
      final result = await _getMovieRecommendations.execute(event.id);

      result.fold(
        (failure) => emit(RecommendationMovieError(failure.message)),
        (data) => emit(RecommendationMovieHasData(data)),
      );
    });
  }
}

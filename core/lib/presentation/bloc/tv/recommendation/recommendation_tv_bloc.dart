import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/tv.dart';

part 'recommendation_tv_event.dart';

part 'recommendation_tv_state.dart';

class RecommendationTvBloc
    extends Bloc<RecommendationTvEvent, RecommendationTvState> {
  final GetTvRecommendations _getRecommendationTv;

  RecommendationTvBloc(this._getRecommendationTv)
      : super(RecommendationTvInitial()) {
    on<RecommendationTvFetched>((event, emit) async {
      emit(RecommendationTvLoading());
      final result = await _getRecommendationTv.execute(event.id);

      result.fold(
        (failure) => emit(RecommendationTvError(failure.message)),
        (data) => emit(RecommendationTvHasData(data)),
      );
    });
  }
}

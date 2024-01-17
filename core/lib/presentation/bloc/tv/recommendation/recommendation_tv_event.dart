part of 'recommendation_tv_bloc.dart';

abstract class RecommendationTvEvent extends Equatable {
  const RecommendationTvEvent();

  @override
  List<Object> get props => [];
}

final class RecommendationTvFetched extends RecommendationTvEvent {
  final int id;

  const RecommendationTvFetched(this.id);

  @override
  List<Object> get props => [id];
}

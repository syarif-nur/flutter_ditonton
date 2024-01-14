part of 'recommendation_movie_bloc.dart';

@immutable
abstract class RecommendationMovieEvent extends Equatable {
  const RecommendationMovieEvent();

  @override
  List<Object> get props => [];
}

final class RecommendationMovieFetched extends RecommendationMovieEvent {
  final int id;

  const RecommendationMovieFetched(this.id);

  @override
  List<Object> get props => [id];
}



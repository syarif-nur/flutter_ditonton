part of 'top_rated_movie_bloc.dart';

@immutable
abstract class TopRatedMovieState extends Equatable {
  const TopRatedMovieState();

  @override
  List<Object> get props => [];
}

class TopRatedMovieInitial extends TopRatedMovieState {}

class TopRatedMovieLoading extends TopRatedMovieState {}

class TopRatedMovieError extends TopRatedMovieState {
  final String message;

  const TopRatedMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedMovieHasData extends TopRatedMovieState {
  final List<Movie> result;

  const TopRatedMovieHasData(this.result);

  @override
  List<Object> get props => [result];
}

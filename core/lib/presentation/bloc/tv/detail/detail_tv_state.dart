part of 'detail_tv_bloc.dart';

abstract class DetailTvState extends Equatable {
  const DetailTvState();

  @override
  List<Object> get props => [];
}

class DetailTvInitial extends DetailTvState {}

class DetailTvLoading extends DetailTvState {}

class DetailTvError extends DetailTvState {
  final String message;

  const DetailTvError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailTvHasData extends DetailTvState {
  final TvDetail result;
  final bool status;

  const DetailTvHasData(this.result, this.status);

  @override
  List<Object> get props => [result];
}

class DetailTvMessage extends DetailTvState {
  final String status;

  const DetailTvMessage(this.status);

  @override
  List<Object> get props => [status];
}

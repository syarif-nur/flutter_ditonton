part of 'detail_tv_bloc.dart';

abstract class DetailTvEvent extends Equatable {
  const DetailTvEvent();

  @override
  List<Object> get props => [];
}

final class DetailTvFetched extends DetailTvEvent {
  final int id;

  const DetailTvFetched(this.id);

  @override
  List<Object> get props => [id];
}

final class AddToWatchlist extends DetailTvEvent {
  final TvDetail tvDetail;

  const AddToWatchlist(this.tvDetail);

  @override
  List<Object> get props => [tvDetail];
}

final class RemoveFromWatchlist extends DetailTvEvent {
  final TvDetail tvDetail;

  const RemoveFromWatchlist(this.tvDetail);

  @override
  List<Object> get props => [tvDetail];
}

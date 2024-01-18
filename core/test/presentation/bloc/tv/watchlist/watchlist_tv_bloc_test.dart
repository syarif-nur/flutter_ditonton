import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_watchlist_tv.dart';
import 'package:core/presentation/bloc/tv/watchlist/watchlist_tv_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main() {
  late WatchlistTvBloc bloc;
  late MockGetWatchlistTv mockGetWatchlistTv;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    bloc = WatchlistTvBloc(mockGetWatchlistTv);
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTv.execute())
          .thenAnswer((_) async => Right([testWatchlistTv]));
      return bloc;
    },
    act: (bloc) => bloc.add(WatchlistTvFetched()),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvHasData([testWatchlistTv]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetWatchlistTv.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return bloc;
    },
    act: (bloc) => bloc.add(WatchlistTvFetched()),
    expect: () => [
      WatchlistTvLoading(),
      const WatchlistTvError("Can't get data"),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );
}

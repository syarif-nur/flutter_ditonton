import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_status_tv.dart';
import 'package:core/domain/usecases/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/save_watchlist_tv.dart';
import 'package:core/presentation/bloc/tv/detail/detail_tv_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'detail_tv_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late DetailTvBloc detailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetWatchListStatusTv mockGetWatchlistStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetWatchlistStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    detailBloc = DetailTvBloc(
      mockGetTvDetail,
      mockGetWatchlistStatusTv,
      mockSaveWatchlistTv,
      mockRemoveWatchlistTv,
    );
  });

  final tId = 1;

  _arrangeUsecase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetWatchlistStatusTv.execute(any)).thenAnswer((_) async => false);
    return detailBloc;
  }

  group('Get Movie Detail', () {
    blocTest<DetailTvBloc, DetailTvState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () => _arrangeUsecase(),
      act: (bloc) => bloc.add(DetailTvFetched(tId)),
      expect: () => [
        DetailTvLoading(),
        DetailTvHasData(testTvDetail, false),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
      },
    );
  });

  group('Watchlist', () {
    blocTest<DetailTvBloc, DetailTvState>(
      'should get the watchlist status',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetWatchlistStatusTv.execute(tId))
            .thenAnswer((_) async => true);
        return detailBloc;
      },
      act: (bloc) => bloc.add(DetailTvFetched(tId)),
      expect: () => [
        DetailTvLoading(),
        DetailTvHasData(testTvDetail, true),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
      },
    );

    blocTest<DetailTvBloc, DetailTvState>(
      'should execute save watchlist when function called',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetWatchlistStatusTv.execute(tId))
            .thenAnswer((_) async => true);
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Success'));
        return detailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
      expect: () => [
        const DetailTvMessage('Added to Watchlist'),
        DetailTvLoading(),
        DetailTvHasData(testTvDetail, true)
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
      },
    );

    blocTest<DetailTvBloc, DetailTvState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetWatchlistStatusTv.execute(tId))
            .thenAnswer((_) async => false);
        when(mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Success'));
        return detailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testTvDetail)),
      expect: () => [
        const DetailTvMessage('Removed from Watchlist'),
        DetailTvLoading(),
        DetailTvHasData(testTvDetail, false)
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(testTvDetail));
      },
    );

    blocTest<DetailTvBloc, DetailTvState>(
      'should update watchlist status when add watchlist success',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetWatchlistStatusTv.execute(tId))
            .thenAnswer((_) async => true);
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Success'));
        return detailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
      expect: () => [
        const DetailTvMessage('Added to Watchlist'),
        DetailTvLoading(),
        DetailTvHasData(testTvDetail, true)
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
      },
    );

    blocTest<DetailTvBloc, DetailTvState>(
      'should update watchlist status when add watchlist faild',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(DatabaseFailure("Failed")));
        when(mockGetWatchlistStatusTv.execute(tId))
            .thenAnswer((_) async => false);
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure("Failed")));
        return detailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
      expect: () => [
        const DetailTvError('Failed'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
      },
    );
  });

  group('on Error', () {
    blocTest<DetailTvBloc, DetailTvState>(
      'should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetWatchlistStatusTv.execute(tId))
            .thenAnswer((_) async => false);
        return detailBloc;
      },
      act: (bloc) => bloc.add(DetailTvFetched(tId)),
      expect: () => [
        DetailTvLoading(),
        const DetailTvError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
      },
    );
  });
}

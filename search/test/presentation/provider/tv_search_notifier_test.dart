import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecase/search_tv.dart';
import 'package:search/presentation/provider/tv_search_notifier.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late TvSearchNotifier provider;
  late MockSearchTv mockSearchTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTv = MockSearchTv();
    provider = TvSearchNotifier(searchTv: mockSearchTv)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTv = Tv(
    backdropPath: "/9In9QgVJx7PlFOAgVHCKKSbo605.jpg",
    genreIds: [16, 35, 10765, 10759],
    id: 60625,
    originalName: "Rick and Morty",
    overview:
    "Rick is a mentally-unbalanced but scientifically gifted old man who has recently reconnected with his family. He spends most of his time involving his young grandson Morty in dangerous, outlandish adventures throughout space and alternate universes. Compounded with Morty's already unstable family life, these events cause Morty much distress at home and school.",
    popularity: 1386.559,
    posterPath: "/cvhNj9eoRBe5SxjCbQTkh05UP5K.jpg",
    firstAirDate: "2013-12-02",
    name: "Rick and Morty",
    voteAverage: 8.701,
    voteCount: 8572,
    originCountry: ["US"],
    originalLanguage: "en",
  );
  final tTvList = <Tv>[tTv];
  final tQuery = 'rick and morty';

  group('search tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
            () async {
          // arrange
          when(mockSearchTv.execute(tQuery))
              .thenAnswer((_) async => Right(tTvList));
          // act
          await provider.fetchTvSearch(tQuery);
          // assert
          expect(provider.state, RequestState.Loaded);
          expect(provider.searchResult, tTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

}

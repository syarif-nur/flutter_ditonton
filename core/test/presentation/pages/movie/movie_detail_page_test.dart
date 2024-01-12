import 'package:core/presentation/bloc/movie/detail/detail_movie_bloc.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/pages/movie/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([DetailMovieBloc])
void main() {
  late MockDetailMovieBloc mockDetailMovieBloc;

  setUp(() {
    mockDetailMovieBloc = MockDetailMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<DetailMovieBloc>.value(
      value: mockDetailMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockDetailMovieBloc.emit(DetailMovieHasData(result, status))).thenReturn(RequestState.Loaded);
    when(mockDetailMovieBloc.movie).thenReturn(testMovieDetail);
    when(mockDetailMovieBloc.recommendationState).thenReturn(RequestState.Loaded);
    when(mockDetailMovieBloc.movieRecommendations).thenReturn(<Movie>[]);
    when(mockDetailMovieBloc.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(mockDetailMovieBloc.movieState).thenReturn(RequestState.Loaded);
    when(mockDetailMovieBloc.movie).thenReturn(testMovieDetail);
    when(mockDetailMovieBloc.recommendationState).thenReturn(RequestState.Loaded);
    when(mockDetailMovieBloc.movieRecommendations).thenReturn(<Movie>[]);
    when(mockDetailMovieBloc.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockDetailMovieBloc.movieState).thenReturn(RequestState.Loaded);
    when(mockDetailMovieBloc.movie).thenReturn(testMovieDetail);
    when(mockDetailMovieBloc.recommendationState).thenReturn(RequestState.Loaded);
    when(mockDetailMovieBloc.movieRecommendations).thenReturn(<Movie>[]);
    when(mockDetailMovieBloc.isAddedToWatchlist).thenReturn(false);
    when(mockDetailMovieBloc.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockDetailMovieBloc.movieState).thenReturn(RequestState.Loaded);
    when(mockDetailMovieBloc.movie).thenReturn(testMovieDetail);
    when(mockDetailMovieBloc.recommendationState).thenReturn(RequestState.Loaded);
    when(mockDetailMovieBloc.movieRecommendations).thenReturn(<Movie>[]);
    when(mockDetailMovieBloc.isAddedToWatchlist).thenReturn(false);
    when(mockDetailMovieBloc.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}

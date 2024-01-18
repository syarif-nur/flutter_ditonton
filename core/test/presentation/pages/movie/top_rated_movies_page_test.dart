import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/bloc/movie/top_rated/top_rated_movie_bloc.dart';
import 'package:core/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMovieBloc])
void main() {
  late MockTopRatedMovieBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMovieBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));

    when(mockBloc.state).thenAnswer((_) => TopRatedMovieLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
        when(mockBloc.stream)
            .thenAnswer((_) => Stream.value(const TopRatedMovieHasData(<Movie>[])));
        when(mockBloc.state)
            .thenAnswer((_) => const TopRatedMovieHasData(<Movie>[]));
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
        when(mockBloc.stream).thenAnswer(
                (_) => Stream.value(const TopRatedMovieError("Error message")));
        when(mockBloc.state)
            .thenAnswer((_) => const TopRatedMovieError("Error message"));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}

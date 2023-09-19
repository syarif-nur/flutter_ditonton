import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularTvPage extends StatefulWidget{
  static const ROUTE_NAME = '/popular-tv';

  @override
  State<PopularTvPage> createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        // Provider.of<PopularMoviesNotifier>(context, listen: false)
        //     .fetchPopularMovies());
    ());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Popular Movies'),
      // ),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Consumer<PopularMoviesNotifier>(
      //     builder: (context, data, child) {
      //       if (data.state == RequestState.Loading) {
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       } else if (data.state == RequestState.Loaded) {
      //         return ListView.builder(
      //           itemBuilder: (context, index) {
      //             final movie = data.movies[index];
      //             return MovieCard(movie);
      //           },
      //           itemCount: data.movies.length,
      //         );
      //       } else {
      //         return Center(
      //           key: Key('error_message'),
      //           child: Text(data.message),
      //         );
      //       }
      //     },
      //   ),
      // ),
    );
  }
}
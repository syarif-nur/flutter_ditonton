import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/state_enum.dart';
import '../../../domain/entities/tv.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv';

  const HomeTvPage({
    super.key,
  });

  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<TvListNotifier>(context, listen: false)
      ..fetchNowPlayingMovies());
    // ..fetchPopularMovies()
    // ..fetchTopRatedMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ditonton'),
          actions: [
            IconButton(
              onPressed: () {
                // Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Now Playing',
                  style: kHeading6,
                ),
                Consumer<TvListNotifier>(builder: (context, data, child) {
                  final state = data.nowPlayingState;
                  if (state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.Loaded) {
                    return TvList(data.nowPlayingMovies);
                  } else {
                    return Text('Failed');
                  }
                }),
                // _buildSubHeading(
                //   title: 'Popular',
                //   onTap: () => Navigator.pushNamed(
                //       context, PopularMoviesPage.ROUTE_NAME),
                // ),
                // Consumer<MovieListNotifier>(builder: (context, data, child) {
                //   final state = data.popularMoviesState;
                //   if (state == RequestState.Loading) {
                //     return Center(
                //       child: CircularProgressIndicator(),
                //     );
                //   } else if (state == RequestState.Loaded) {
                //     return MovieList(data.popularMovies);
                //   } else {
                //     return Text('Failed');
                //   }
                // }),
                // _buildSubHeading(
                //   title: 'Top Rated',
                //   onTap: () => Navigator.pushNamed(
                //       context, TopRatedMoviesPage.ROUTE_NAME),
                // ),
                // Consumer<MovieListNotifier>(
                //   builder: (context, data, child) {
                //     final state = data.topRatedMoviesState;
                //     if (state == RequestState.Loading) {
                //       return Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     } else if (state == RequestState.Loaded) {
                //       return MovieList(data.topRatedMovies);
                //     } else {
                //       return Text('Failed');
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tv;

  TvList(this.tv);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvData = tv[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tvData.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvData.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tv.length,
      ),
    );
  }
}

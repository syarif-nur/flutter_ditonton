import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/bloc/tv/now_playing/now_playing_tv_bloc.dart';
import 'package:core/presentation/bloc/tv/popular/popular_tv_bloc.dart';
import 'package:core/presentation/bloc/tv/top_rated/top_rated_tv_bloc.dart';
import 'package:core/presentation/pages/tv/popular_tv_page.dart';
import 'package:core/utils/routes.dart';
import 'package:core/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:core/presentation/pages/tv/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/tv.dart';
import '../../../styles/text_styles.dart';
import '../../../utils/constants.dart';
import '../../../utils/state_enum.dart';
import '../../provider/tv_list_notifier.dart';
import 'now_playing_tv_page.dart';

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
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ditonton'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SEARCH_ROUTE_TV);
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
                _buildSubHeading(
                    title: 'Now Playing',
                    onTap: () => {
                          Navigator.pushNamed(
                              context, NowPlayingTvPage.ROUTE_NAME),
                        }),
                BlocBuilder<NowPlayingTvBloc, NowPlayingTvState>(
                    builder: (context, state) {
                  if (state is NowPlayingTvLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NowPlayingTvHasData) {
                    return TvList(state.result);
                  } else {
                    return Text('Failed');
                  }
                }),
                _buildSubHeading(
                    title: 'Popular',
                    onTap: () => {
                          Navigator.pushNamed(
                              context, PopularTvPage.ROUTE_NAME),
                        }),
                BlocBuilder<PopularTvBloc, PopularTvState>(
                    builder: (context, state) {
                  if (state is PopularTvLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularTvHasData) {
                    return TvList(state.result);
                  } else {
                    return Text('Failed');
                  }
                }),
                _buildSubHeading(
                    title: 'Top Rated',
                    onTap: () => {
                          Navigator.pushNamed(
                              context, TopRatedTvPage.ROUTE_NAME),
                        }),
                BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
                  builder: (context, state) {
                    if (state is TopRatedTvLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TopRatedTvHasData) {
                      return TvList(state.result);
                    } else {
                      return Text('Failed');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
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

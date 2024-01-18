import 'package:core/presentation/bloc/tv/watchlist/watchlist_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/utils.dart';
import '../../widgets/tv_card_list.dart';

class WatchListTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  @override
  State<WatchListTvPage> createState() => _WatchListTvPageState();
}

class _WatchListTvPageState extends State<WatchListTvPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    final watchlistBloc = context.read<WatchlistTvBloc>();
    watchlistBloc.add(WatchlistTvFetched());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    final watchlistBloc = context.read<WatchlistTvBloc>();
    watchlistBloc.add(WatchlistTvFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
          builder: (context, state) {
            if (state is WatchlistTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistTvHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is WatchlistTvError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text("Error"),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/state_enum.dart';
import '../../../utils/utils.dart';
import '../../provider/watchlist_tv_notifier.dart';
import '../../widgets/tv_card_list.dart';


class WatchListTvPage extends StatefulWidget{
  static const ROUTE_NAME = '/watchlist-tv';

  @override
  State<WatchListTvPage> createState() => _WatchListTvPageState();
}

class _WatchListTvPageState extends State<WatchListTvPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchListTvNotifier>(context, listen: false)
            .fetchWatchlistTv());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchListTvNotifier>(context, listen: false)
        .fetchWatchlistTv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchListTvNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.watchlistState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.watchlistTv[index];
                  return TvCard(tv);
                },
                itemCount: data.watchlistTv.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
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
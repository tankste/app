import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:station/ui/details/station_details_page.dart';
import 'package:station/ui/favorites/cubit/favorite_list_cubit.dart';
import 'package:station/ui/favorites/cubit/favorite_list_state.dart';

class FavoriteListPage extends StatelessWidget {
  final String filter;

  const FavoriteListPage({required this.filter, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteListCubit(filter),
      child: BlocConsumer<FavoriteListCubit, FavoriteListState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(tr('station.favorites.title'))),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, FavoriteListState state) {
    if (state is LoadingFavoriteListState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ErrorFavoriteListState) {
      //TODO: outsource to own widget
      return Center(
        child: Column(
          children: [
            const Spacer(),
            Text(
              tr('generic.error.title'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                (tr('generic.error.long')),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  context.read<FavoriteListCubit>().onRetryClicked();
                },
                child: Text(tr('generic.retry.long')),
              ),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(tr('generic.error.details.title')),
                      content: Text(state.errorDetails),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(tr('generic.ok')),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(tr('generic.error.details.show')),
            ),
            const Spacer(),
          ],
        ),
      );
    } else if (state is EmptyFavoriteListState) {
      return Center(child: Text(tr('station.favorites.empty')));
    } else if (state is DataFavoriteListState) {
      return RefreshIndicator(
        onRefresh: () {
          context.read<FavoriteListCubit>().onRefresh();
          return Future.value();
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: state.stations.length,
          itemBuilder: (context, index) {
            final FavoriteStationItem item = state.stations[index];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),

              child: Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  // borderRadius: BorderRadius.circular(Theme.of(context).cardTheme),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StationDetailsPage(
                          stationId: item.stationId,
                          markerLabel: item.name,
                          activeGasPriceFilter: filter,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 12,
                      right: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              item.city,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: item.price.color,
                          ),
                          child: Text(
                            item.price.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Container();
  }
}

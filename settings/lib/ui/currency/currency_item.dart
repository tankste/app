import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/ui/currency/cubit/currency_item_cubit.dart';
import 'package:settings/ui/currency/cubit/currency_item_state.dart';
import 'package:settings/ui/currency/currency_selection_dialog.dart';
import 'package:station/model/currency_model.dart';

class CurrencyItem extends StatelessWidget {
  const CurrencyItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CurrencyItemCubit(),
        child: BlocConsumer<CurrencyItemCubit, CurrencyItemState>(
            listener: (context, state) {},
            builder: (context, state) {
              return _buildyBody(context, state);
            }));
  }

  Widget _buildyBody(BuildContext context, CurrencyItemState state) {
    if (state is LoadingCurrencyItemState) {
      return ListTile(
          minLeadingWidth: 10,
          leading: const Icon(Icons.euro),
          title: Text(tr('settings.app.currency.title')),
          subtitle: const Text("..."));
    } else if (state is ErrorCurrencyItemState) {
      return ListTile(
          minLeadingWidth: 10,
          onTap: () {
            context.read<CurrencyItemCubit>().onRetryClicked();
          },
          leading: const Icon(Icons.euro),
          title: Text(tr('settings.app.currency.title')),
          subtitle: Text(tr('settings.item_error')));
    } else if (state is ValueCurrencyItemState) {
      return ListTile(
          minLeadingWidth: 10,
          onTap: () {
            _showSelectionDialog(
                context, state.availableCurrencies, state.currencyType);
          },
          leading: const Icon(Icons.euro),
          title: Text(tr('settings.app.currency.title')),
          subtitle: Text(state.valueLabel));
    }

    return Container();
  }

  void _showSelectionDialog(BuildContext context,
      List<CurrencyModel> availableCurrencies, CurrencyType selectedCurrency) {
    showDialog(
        context: context,
        builder: (context) {
          return CurrencySelectionDialog(
              availableCurrencies: availableCurrencies,
              selection: selectedCurrency);
        }).then((currency) {
      if (currency != null) {
        context.read<CurrencyItemCubit>().onCurrencyChanged(currency);
      }
    });
  }
}

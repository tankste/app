import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:station/model/currency_model.dart';

class CurrencySelectionDialog extends StatefulWidget {
  final List<CurrencyModel> availableCurrencies;
  final CurrencyType selection;

  const CurrencySelectionDialog(
      {required this.availableCurrencies, required this.selection, super.key});

  @override
  State<StatefulWidget> createState() => CurrencySelectionDialogState();
}

class CurrencySelectionDialogState extends State<CurrencySelectionDialog> {
  late CurrencyType selectedCurrency;

  @override
  void initState() {
    selectedCurrency = widget.selection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text(tr('settings.app.currency.title')),
        children: widget.availableCurrencies
                .map<Widget>(
                  (currency) => RadioListTile<CurrencyType>(
                    value: currency.currency,
                    groupValue: selectedCurrency,
                    onChanged: (_) {
                      setState(() {
                        selectedCurrency = currency.currency;
                      });
                      Navigator.of(context).pop(currency);
                    },
                    title: Text("${currency.label} (${currency.symbol})"),
                  ),
                )
                .toList() +
            [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Spacer(),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        child: Text(tr('generic.cancel')))
                  ],
                ),
              )
            ]);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report/ui/form/cubit/report_form_cubit.dart';
import 'package:report/ui/form/cubit/report_form_state.dart';

class ReportFormPage extends StatelessWidget {
  final int stationId;
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _brandTextController = TextEditingController();
  final TextEditingController _streetTextController = TextEditingController();
  final TextEditingController _houseNumberTextController =
      TextEditingController();
  final TextEditingController _postCodeTextController = TextEditingController();
  final TextEditingController _cityTextController = TextEditingController();
  final TextEditingController _countryTextController = TextEditingController();
  final TextEditingController _latitudeTextController = TextEditingController();
  final TextEditingController _longitudeTextController =
      TextEditingController();
  final TextEditingController _priceE5TextController = TextEditingController();
  final TextEditingController _priceE10TextController = TextEditingController();
  final TextEditingController _priceDieselTextController =
      TextEditingController();
  final TextEditingController _openTimesTextController =
      TextEditingController();
  bool _hasInit = false;

  ReportFormPage({
    required this.stationId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ReportFormCubit(stationId),
        child: BlocConsumer<ReportFormCubit, ReportFormState>(
            listener: (context, state) {
          if (state is SavedFormReportFormState) {
            const snackBar = SnackBar(
              content: Text('Meldung erfolgreich versendet.'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            Navigator.of(context).pop();
          } else if (state is SaveErrorFormReportFormState) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Fehler'),
                    content: Text(state.errorDetails),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Ok')),
                    ],
                  );
                });
          }

          if (state is FormReportFormState) {
            if (!_hasInit) {
              //TODO: is there a smarter way to do this?
              _nameTextController.text = state.name;
              _brandTextController.text = state.brand;
              _streetTextController.text = state.addressStreet;
              _houseNumberTextController.text = state.addressHouseNumber;
              _postCodeTextController.text = state.addressPostCode;
              _cityTextController.text = state.addressCity;
              _countryTextController.text = state.addressCountry;
              _latitudeTextController.text = state.locationLatitude;
              _longitudeTextController.text = state.locationLongitude;
              _priceE5TextController.text = state.priceE5;
              _priceE10TextController.text = state.priceE10;
              _priceDieselTextController.text = state.priceDiesel;
              _openTimesTextController.text = state.openTimes;
              _hasInit = true;
            }
          }
        }, builder: (context, state) {
          return Scaffold(
              appBar: AppBar(title: const Text("Fehlerhafte Daten melden")),
              body: SafeArea(child: _buildBody(context, state)));
        }));
  }

  Widget _buildBody(BuildContext context, ReportFormState state) {
    if (state is LoadingReportFormState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ErrorReportFormState) {
      return Center(
          child: Column(children: [
        const Spacer(),
        Text("Fehler!", style: Theme.of(context).textTheme.headlineSmall),
        Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "Es ist ein Fehler aufgetreten. Bitte prüfe deine Internetverbindung oder versuche es später erneut.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            )),
        Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
                onPressed: () {
                  context.read<ReportFormCubit>().onRetryClicked();
                },
                child: const Text("Wiederholen"))),
        TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Fehler Details'),
                      content: Text(state.errorDetails),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Ok')),
                      ],
                    );
                  });
            },
            child: const Text("Fehler anzeigen")),
        const Spacer(),
      ]));
    } else if (state is FormReportFormState) {
      return SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Allgemein", style: Theme.of(context).textTheme.titleLarge),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: null,
                  ),
                  controller: _nameTextController,
                  onChanged: (String text) {
                    context.read<ReportFormCubit>().onNameChanged(text);
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Marke (Firmenname)",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: null,
                  ),
                  controller: _brandTextController,
                  onChanged: (String text) {
                    context.read<ReportFormCubit>().onBrandChanged(text);
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text("Addresse",
                    style: Theme.of(context).textTheme.titleLarge)),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(children: [
                  Flexible(
                      flex: 4,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Straße",
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          errorText: null,
                        ),
                        controller: _streetTextController,
                        onChanged: (String text) {
                          context
                              .read<ReportFormCubit>()
                              .onAddressStreetChanged(text);
                        },
                      )),
                  const SizedBox(width: 16),
                  Flexible(
                      flex: 2,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Hausnummer",
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          errorText: null,
                        ),
                        controller: _houseNumberTextController,
                        onChanged: (String text) {
                          context
                              .read<ReportFormCubit>()
                              .onAddressHouseNumberChanged(text);
                        },
                      )),
                ])),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(children: [
                  Flexible(
                      flex: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Postleitszahl",
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          errorText: null,
                        ),
                        controller: _postCodeTextController,
                        onChanged: (String text) {
                          context
                              .read<ReportFormCubit>()
                              .onAddressPostCodeChanged(text);
                        },
                      )),
                  const SizedBox(width: 16),
                  Flexible(
                      flex: 2,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Stadt",
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          errorText: null,
                        ),
                        controller: _cityTextController,
                        onChanged: (String text) {
                          context
                              .read<ReportFormCubit>()
                              .onAddressCityChanged(text);
                        },
                      )),
                ])),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Land",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: null,
                  ),
                  controller: _countryTextController,
                  onChanged: (String text) {
                    context
                        .read<ReportFormCubit>()
                        .onAddressCountryChanged(text);
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text("Position",
                    style: Theme.of(context).textTheme.titleLarge)),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Latitude",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: null,
                  ),
                  controller: _latitudeTextController,
                  onChanged: (String text) {
                    context
                        .read<ReportFormCubit>()
                        .onLocationLatitudeChanged(text);
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Longitude",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: null,
                  ),
                  controller: _longitudeTextController,
                  onChanged: (String text) {
                    context
                        .read<ReportFormCubit>()
                        .onLocationLongitudeChanged(text);
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text("Preise",
                    style: Theme.of(context).textTheme.titleLarge)),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "E5",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: null,
                  ),
                  controller: _priceE5TextController,
                  onChanged: (String text) {
                    context.read<ReportFormCubit>().onPriceE5Changed(text);
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "E10",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: null,
                  ),
                  controller: _priceE10TextController,
                  onChanged: (String text) {
                    context.read<ReportFormCubit>().onPriceE10Changed(text);
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Diesel",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: null,
                  ),
                  controller: _priceDieselTextController,
                  onChanged: (String text) {
                    context.read<ReportFormCubit>().onPriceDieselChanged(text);
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text("Öffnungszeiten",
                    style: Theme.of(context).textTheme.titleLarge)),
            // Padding(
            //     padding: const EdgeInsets.only(top: 16),
            //     child: TextFormField(
            //       decoration: InputDecoration(
            //         labelText: "Aktuell geöffnet",
            //         border: const OutlineInputBorder(),
            //         alignLabelWithHint: true,
            //         errorText: null,
            //       ),
            //       controller: _openTimesTextController,
            //       onChanged: (String text) {
            //         // context.read<ReportFormCubit>().onOpenTimesStateChanged(text);
            //       },
            //     )),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Öffnungszeiten",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: null,
                  ),
                  maxLines: 7,
                  controller: _openTimesTextController,
                  onChanged: (String text) {
                    context.read<ReportFormCubit>().onOpenTimesChanged(text);
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    const Spacer(),
                    state is SavingFormReportFormState
                        ? const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )))
                        : Container(),
                    ElevatedButton(
                        onPressed: state is! SavingFormReportFormState
                            ? () {
                                context.read<ReportFormCubit>().onSaveClicked();
                              }
                            : null,
                        child: const Text("Senden")),
                  ],
                )),
          ],
        ),
      ));
    }

    return Container();
  }
}

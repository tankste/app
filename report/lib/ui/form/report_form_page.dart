import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report/ui/form/availability_selection_dialog.dart';
import 'package:report/ui/form/cubit/report_form_cubit.dart';
import 'package:report/ui/form/cubit/report_form_state.dart';
import 'package:report/ui/form/open_time_state_selection_dialog.dart';

class ReportFormPage extends StatelessWidget {
  final int stationId;
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _brandTextController = TextEditingController();
  final TextEditingController _availabilityTextController =
      TextEditingController();
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
  final TextEditingController _openTimeStateTextController =
      TextEditingController();
  final TextEditingController _openTimesTextController =
      TextEditingController();
  final TextEditingController _noteTextController = TextEditingController();
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
            SnackBar snackBar = SnackBar(
              content: Text(tr('report.form.sent')),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            Navigator.of(context).pop();
          } else if (state is SaveErrorFormReportFormState) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(tr('generic.error.title')),
                    content: Text(state.errorDetails),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(tr('generic.ok'))),
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

            _availabilityTextController.text = state.availabilityLabel;
            _openTimeStateTextController.text = state.openTimesStateLabel;
          }
        }, builder: (context, state) {
          return Scaffold(
              appBar: AppBar(title: Text(tr('report.title'))),
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
        Text(tr('generic.error.title'), style: Theme.of(context).textTheme.headlineSmall),
        Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              tr('generic.error.long'),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            )),
        Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
                onPressed: () {
                  context.read<ReportFormCubit>().onRetryClicked();
                },
                child: Text(tr('generic.retry.long')))),
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
                            child: Text(tr('generic.ok'))),
                      ],
                    );
                  });
            },
            child: Text(tr('generic.error.details.show'))),
        const Spacer(),
      ]));
    } else if (state is FormReportFormState) {
      return SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr('report.general.title'), style: Theme.of(context).textTheme.titleLarge),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: tr('report.general.name'),
                    border: const OutlineInputBorder(),
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
                  decoration: InputDecoration(
                    labelText: tr('report.general.brand'),
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: null,
                  ),
                  controller: _brandTextController,
                  onChanged: (String text) {
                    context.read<ReportFormCubit>().onBrandChanged(text);
                  },
                )),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextFormField(
                decoration:  InputDecoration(
                    labelText: tr('report.availability.title'),
                    errorText: null,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                    suffixIcon: const Icon(Icons.arrow_drop_down)),
                readOnly: true,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AvailabilitySelectionDialog(
                            selection: state.availability);
                      }).then((availability) {
                    if (availability != null) {
                      context
                          .read<ReportFormCubit>()
                          .onAvailabilityChanged(availability);
                    }
                  });
                },
                controller: _availabilityTextController,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(tr('report.address.title'),
                    style: Theme.of(context).textTheme.titleLarge)),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(children: [
                  Flexible(
                      flex: 4,
                      child: TextFormField(
                        decoration:  InputDecoration(
                          labelText: tr('report.address.street'),
                          border: const OutlineInputBorder(),
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
                        decoration:  InputDecoration(
                          labelText: tr('report.address.house_number'),
                          border: const OutlineInputBorder(),
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
                        decoration:  InputDecoration(
                          labelText: tr('report.address.post_code'),
                          border: const OutlineInputBorder(),
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
                        decoration:  InputDecoration(
                          labelText: tr('report.address.city'),
                          border: const OutlineInputBorder(),
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
                  decoration:  InputDecoration(
                    labelText: tr('report.address.country'),
                    border: const OutlineInputBorder(),
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
                child: Text(tr('report.location.title'),
                    style: Theme.of(context).textTheme.titleLarge)),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration:  InputDecoration(
                    labelText: tr('report.location.latitude'),
                    border: const OutlineInputBorder(),
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
                  decoration: InputDecoration(
                    labelText: tr('report.location.longitude'),
                    border: const OutlineInputBorder(),
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
                child: Text(tr('station.prices.title'),
                    style: Theme.of(context).textTheme.titleLarge)),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration:  InputDecoration(
                    labelText: tr('station.gas.e5'),
                    border: const OutlineInputBorder(),
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
                  decoration: InputDecoration(
                    labelText: tr('station.gas.e10'),
                    border: const OutlineInputBorder(),
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
                  decoration: InputDecoration(
                    labelText: tr('station.gas.diesel'),
                    border: const OutlineInputBorder(),
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
                child: Text(tr('station.open_times.title'),
                    style: Theme.of(context).textTheme.titleLarge)),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextFormField(
                decoration:  InputDecoration(
                    labelText: tr('report.open_times.title'),
                    errorText: null,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                    suffixIcon: const Icon(Icons.arrow_drop_down)),
                readOnly: true,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return OpenTimeStateSelectionDialog(
                            selection: state.openTimesState);
                      }).then((openTimeState) {
                    if (openTimeState != null) {
                      context
                          .read<ReportFormCubit>()
                          .onOpenTimesStateChanged(openTimeState);
                    }
                  });
                },
                controller: _openTimeStateTextController,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: tr('station.open_times.title'),
                    border: const OutlineInputBorder(),
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
                padding: const EdgeInsets.only(top: 24),
                child: Text(tr('report.misc.title'),
                    style: Theme.of(context).textTheme.titleLarge)),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration:  InputDecoration(
                    labelText: tr('report.misc.comment.label'),
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                    helperText: tr('report.misc.comment.hint'),
                    errorText: null,
                  ),
                  maxLines: 7,
                  controller: _noteTextController,
                  onChanged: (String text) {
                    context.read<ReportFormCubit>().onNoteChanged(text);
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
                        child: Text(tr('generic.send')))
                  ],
                )),
          ],
        ),
      ));
    }

    return Container();
  }
}

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:report/di/report_module_factory.dart';
import 'package:report/model/report_model.dart';
import 'package:report/repository/report_repository.dart';
import 'package:report/ui/form/cubit/report_form_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:station/di/station_module_factory.dart';
import 'package:station/model/open_time.dart';
import 'package:station/model/price_model.dart';
import 'package:station/repository/open_time_repository.dart';
import 'package:station/repository/price_repository.dart';
import 'package:station/repository/station_repository.dart';

class ReportFormCubit extends Cubit<ReportFormState> {
  final StationRepository _stationRepository =
      StationModuleFactory.createStationRepository();

  final PriceRepository _priceRepository =
      StationModuleFactory.createPriceRepository();

  final OpenTimeRepository _openTimeRepository =
      StationModuleFactory.createOpenTimeRepository();

  final ReportRepository _reportRepository =
      ReportModuleFactory.createReportRepository();

  final int stationId;
  String _originalName = "";
  String _name = "";
  String _originalBrand = "";
  String _brand = "";
  String _originalAddressStreet = "";
  String _addressStreet = "";
  String _originalAddressHouseNumber = "";
  String _addressHouseNumber = "";
  String _originalAddressPostCode = "";
  String _addressPostCode = "";
  String _originalAddressCity = "";
  String _addressCity = "";
  String _originalAddressCountry = "";
  String _addressCountry = "";
  String _originalLocationLatitude = "";
  String _locationLatitude = "";
  String _originalLocationLongitude = "";
  String _locationLongitude = "";
  String _originalPriceE5 = "";
  String _priceE5 = "";
  String _originalPriceE10 = "";
  String _priceE10 = "";
  String _originalPriceDiesel = "";
  String _priceDiesel = "";
  String _originalOpenTimesState = "";
  String _openTimesState = "";
  String _openTimesStateLabel = "";
  String _originalOpenTimes = "";
  String _openTimes = "";
  String _availability = "";
  String _availabilityLabel = "";
  String _note = "";

  ReportFormCubit(this.stationId) : super(LoadingReportFormState()) {
    _fetchStation();
  }

  void _fetchStation() {
    emit(LoadingReportFormState());

    CombineLatestStream.combine3(_stationRepository.get(stationId),
        _priceRepository.list(stationId), _openTimeRepository.list(stationId),
        (stationResult, priceResult, openTimesResult) {
      return stationResult.when((station) {
        return priceResult.when((prices) {
          return openTimesResult.when((openTimes) {
            _originalName = station.name.isNotEmpty ? station.name : "-";
            _name = station.name.isNotEmpty ? station.name : "-";
            _originalBrand = station.brand.isNotEmpty ? station.brand : "-";
            _brand = station.brand.isNotEmpty ? station.brand : "-";
            _originalAddressStreet = station.address.street.isNotEmpty
                ? station.address.street
                : "-";
            _addressStreet = station.address.street.isNotEmpty
                ? station.address.street
                : "-";
            _originalAddressHouseNumber = station.address.houseNumber.isNotEmpty
                ? station.address.houseNumber
                : "-";
            _addressHouseNumber = station.address.houseNumber.isNotEmpty
                ? station.address.houseNumber
                : "-";
            _originalAddressPostCode = station.address.postCode.isNotEmpty
                ? station.address.postCode
                : "-";
            _addressPostCode = station.address.postCode.isNotEmpty
                ? station.address.postCode
                : "-";
            _originalAddressCity =
                station.address.city.isNotEmpty ? station.address.city : "-";
            _addressCity =
                station.address.city.isNotEmpty ? station.address.city : "-";
            _originalAddressCountry = station.address.country.isNotEmpty
                ? station.address.country
                : "-";
            _addressCountry = station.address.country.isNotEmpty
                ? station.address.country
                : "-";
            _originalLocationLatitude = station.coordinate.latitude.toString();
            _locationLatitude = station.coordinate.latitude.toString();
            _originalLocationLongitude =
                station.coordinate.longitude.toString();
            _locationLongitude = station.coordinate.longitude.toString();
            _originalPriceE5 = prices
                    .firstWhereOrNull((p) => p.fuelType == FuelType.e5)
                    ?.price
                    .toString() ??
                "-";
            _priceE5 = prices
                    .firstWhereOrNull((p) => p.fuelType == FuelType.e5)
                    ?.price
                    .toString() ??
                "-";
            _originalPriceE10 = prices
                    .firstWhereOrNull((p) => p.fuelType == FuelType.e10)
                    ?.price
                    .toString() ??
                "-";
            _priceE10 = prices
                    .firstWhereOrNull((p) => p.fuelType == FuelType.e10)
                    ?.price
                    .toString() ??
                "-";
            _originalPriceDiesel = prices
                    .firstWhereOrNull((p) => p.fuelType == FuelType.diesel)
                    ?.price
                    .toString() ??
                "-";
            _priceDiesel = prices
                    .firstWhereOrNull((p) => p.fuelType == FuelType.diesel)
                    ?.price
                    .toString() ??
                "-";
            _originalOpenTimesState = station.isOpen.toString();
            _openTimesState = station.isOpen.toString();
            _openTimesStateLabel = station.isOpen ? "Geöffnet" : "Geschlossen";
            _originalOpenTimes = _genOpenTimes(openTimes);
            _openTimes = _genOpenTimes(openTimes);
            _availability = "available";
            _availabilityLabel = "Verfügbar";
            _note = "";

            return FormReportFormState(
                name: _name,
                brand: _brand,
                availability: _availability,
                availabilityLabel: _availabilityLabel,
                addressStreet: _addressStreet,
                addressHouseNumber: _addressHouseNumber,
                addressPostCode: _addressPostCode,
                addressCity: _addressCity,
                addressCountry: _addressCountry,
                locationLatitude: _locationLatitude,
                locationLongitude: _locationLongitude,
                priceE5: _priceE5,
                priceE10: _priceE10,
                priceDiesel: _priceDiesel,
                openTimesState: _openTimesState,
                openTimesStateLabel: _openTimesStateLabel,
                openTimes: _openTimes,
                note: _note);
          }, (error) {
            return ErrorReportFormState(errorDetails: error.toString());
          });
        }, (error) {
          return ErrorReportFormState(errorDetails: error.toString());
        });
      }, (error) {
        return ErrorReportFormState(errorDetails: error.toString());
      });
    }).first.then((result) {
      if (isClosed) {
        return;
      }

      emit(result);
    });
  }

  String _genOpenTimes(List<OpenTimeModel> openTimes) {
    List<String?> items = [];

    items.add(_genOpenTimeRow(OpenTimeDay.monday,
        openTimes.where((ot) => ot.day == OpenTimeDay.monday).toList()));
    items.add(_genOpenTimeRow(OpenTimeDay.tuesday,
        openTimes.where((ot) => ot.day == OpenTimeDay.tuesday).toList()));
    items.add(_genOpenTimeRow(OpenTimeDay.wednesday,
        openTimes.where((ot) => ot.day == OpenTimeDay.wednesday).toList()));
    items.add(_genOpenTimeRow(OpenTimeDay.thursday,
        openTimes.where((ot) => ot.day == OpenTimeDay.thursday).toList()));
    items.add(_genOpenTimeRow(OpenTimeDay.friday,
        openTimes.where((ot) => ot.day == OpenTimeDay.friday).toList()));
    items.add(_genOpenTimeRow(OpenTimeDay.saturday,
        openTimes.where((ot) => ot.day == OpenTimeDay.saturday).toList()));
    items.add(_genOpenTimeRow(OpenTimeDay.sunday,
        openTimes.where((ot) => ot.day == OpenTimeDay.sunday).toList()));
    items.add(_genOpenTimeRow(OpenTimeDay.publicHoliday,
        openTimes.where((ot) => ot.day == OpenTimeDay.publicHoliday).toList()));

    return items.whereNotNull().toList().join("\n\n");
  }

  String? _genOpenTimeRow(OpenTimeDay day, List<OpenTimeModel> openTimes) {
    String dayLabel = "";
    switch (day) {
      case OpenTimeDay.monday:
        dayLabel = "Montag";
        break;
      case OpenTimeDay.tuesday:
        dayLabel = "Dienstag";
        break;
      case OpenTimeDay.wednesday:
        dayLabel = "Mittwoch";
        break;
      case OpenTimeDay.thursday:
        dayLabel = "Donnerstag";
        break;
      case OpenTimeDay.friday:
        dayLabel = "Freitag";
        break;
      case OpenTimeDay.saturday:
        dayLabel = "Samstag";
        break;
      case OpenTimeDay.sunday:
        dayLabel = "Sonntag";
        break;
      case OpenTimeDay.publicHoliday:
        dayLabel = "Feiertag";
        break;
      default:
        dayLabel = "Unbekannt";
    }

    if (openTimes.isEmpty) {
      if (day == OpenTimeDay.publicHoliday) {
        return null;
      } else {
        return "$dayLabel: Geschlossen";
      }
    }

    DateFormat timeFormat = DateFormat('HH:mm');
    return "$dayLabel: ${openTimes.map((ot) => "${timeFormat.format(ot.startTime)} - ${timeFormat.format(ot.endTime)}").join("\n")}";
  }

  void onRetryClicked() {
    _fetchStation();
  }

  void onNameChanged(String value) {
    _name = value;
  }

  void onBrandChanged(String value) {
    _brand = value;
  }

  void onAvailabilityChanged(String value) {
    _availability = value;
    if (value == "available") {
      _availabilityLabel = "Verfügbar";
    } else if (value == "temporary_closed") {
      _availabilityLabel = "Temporär geschlossen";
    } else {
      _availabilityLabel = "Dauerhaft geschlossen";
    }

    emit(FormReportFormState(
      brand: _brand,
      name: _name,
      availability: _availability,
      availabilityLabel: _availabilityLabel,
      addressStreet: _addressStreet,
      addressHouseNumber: _addressHouseNumber,
      addressPostCode: _addressPostCode,
      addressCity: _addressCity,
      addressCountry: _addressCountry,
      locationLatitude: _locationLatitude,
      locationLongitude: _locationLongitude,
      priceE5: _priceE5,
      priceE10: _priceE10,
      priceDiesel: _priceDiesel,
      openTimesState: _openTimesState,
      openTimesStateLabel: _openTimesStateLabel,
      openTimes: _openTimes,
      note: _note,
    ));
  }

  void onAddressStreetChanged(String value) {
    _addressStreet = value;
  }

  void onAddressHouseNumberChanged(String value) {
    _addressHouseNumber = value;
  }

  void onAddressPostCodeChanged(String value) {
    _addressPostCode = value;
  }

  void onAddressCityChanged(String value) {
    _addressCity = value;
  }

  void onAddressCountryChanged(String value) {
    _addressCountry = value;
  }

  void onLocationLatitudeChanged(String value) {
    _locationLatitude = value;
  }

  void onLocationLongitudeChanged(String value) {
    _locationLongitude = value;
  }

  void onPriceE5Changed(String value) {
    _priceE5 = value;
  }

  void onPriceE10Changed(String value) {
    _priceE10 = value;
  }

  void onPriceDieselChanged(String value) {
    _priceDiesel = value;
  }

  void onOpenTimesStateChanged(String value) {
    _openTimesState = value;
    if (value == "true") {
      _openTimesStateLabel = "Geöffnet";
    } else {
      _openTimesStateLabel = "Geschlossen";
    }

    emit(FormReportFormState(
      brand: _brand,
      name: _name,
      availability: _availability,
      availabilityLabel: _availabilityLabel,
      addressStreet: _addressStreet,
      addressHouseNumber: _addressHouseNumber,
      addressPostCode: _addressPostCode,
      addressCity: _addressCity,
      addressCountry: _addressCountry,
      locationLatitude: _locationLatitude,
      locationLongitude: _locationLongitude,
      priceE5: _priceE5,
      priceE10: _priceE10,
      priceDiesel: _priceDiesel,
      openTimesState: _openTimesState,
      openTimesStateLabel: _openTimesStateLabel,
      openTimes: _openTimes,
      note: _note,
    ));
  }

  void onOpenTimesChanged(String value) {
    _openTimes = value;
  }

  void onNoteChanged(String value) {
    _note = value;
  }

  void onSaveClicked() {
    _submit();
  }

  void _submit() {
    emit(SavingFormReportFormState(
      brand: _brand,
      name: _name,
      availability: _availability,
      availabilityLabel: _availabilityLabel,
      addressStreet: _addressStreet,
      addressHouseNumber: _addressHouseNumber,
      addressPostCode: _addressPostCode,
      addressCity: _addressCity,
      addressCountry: _addressCountry,
      locationLatitude: _locationLatitude,
      locationLongitude: _locationLongitude,
      priceE5: _priceE5,
      priceE10: _priceE10,
      priceDiesel: _priceDiesel,
      openTimesState: _openTimesState,
      openTimesStateLabel: _openTimesStateLabel,
      openTimes: _openTimes,
      note: _note,
    ));

    List<ReportModel?> newReports = [];

    newReports.add(_createReport(ReportField.name, _originalName, _name));
    newReports.add(_createReport(ReportField.brand, _originalBrand, _brand));
    newReports.add(
        _createReport(ReportField.availability, "available", _availability));
    newReports.add(_createReport(
        ReportField.addressStreet, _originalAddressStreet, _addressStreet));
    newReports.add(_createReport(ReportField.addressHouseNumber,
        _originalAddressHouseNumber, _addressHouseNumber));
    newReports.add(_createReport(ReportField.addressPostCode,
        _originalAddressPostCode, _addressPostCode));
    newReports.add(_createReport(
        ReportField.addressCity, _originalAddressCity, _addressCity));
    newReports.add(_createReport(
        ReportField.addressCountry, _originalAddressCountry, _addressCountry));
    newReports.add(_createReport(ReportField.locationLatitude,
        _originalLocationLatitude, _locationLatitude));
    newReports.add(_createReport(ReportField.locationLongitude,
        _originalLocationLongitude, _locationLongitude));
    newReports
        .add(_createReport(ReportField.priceE5, _originalPriceE5, _priceE5));
    newReports
        .add(_createReport(ReportField.priceE10, _originalPriceE10, _priceE10));
    newReports.add(_createReport(
        ReportField.priceDiesel, _originalPriceDiesel, _priceDiesel));
    newReports.add(_createReport(
        ReportField.openTimesState, _originalOpenTimesState, _openTimesState));
    newReports.add(
        _createReport(ReportField.openTimes, _originalOpenTimes, _openTimes));
    newReports.add(_createReport(ReportField.note, "", _note));

    if (newReports.whereNotNull().isEmpty) {
      emit(SavedFormReportFormState(
        brand: _brand,
        name: _name,
        availability: _availability,
        availabilityLabel: _availabilityLabel,
        addressStreet: _addressStreet,
        addressHouseNumber: _addressHouseNumber,
        addressPostCode: _addressPostCode,
        addressCity: _addressCity,
        addressCountry: _addressCountry,
        locationLatitude: _locationLatitude,
        locationLongitude: _locationLongitude,
        priceE5: _priceE5,
        priceE10: _priceE10,
        priceDiesel: _priceDiesel,
        openTimesState: _openTimesState,
        openTimesStateLabel: _openTimesStateLabel,
        openTimes: _openTimes,
        note: _note,
      ));
      return;
    }

    Future.wait(newReports
        .whereNotNull()
        .map((r) => _reportRepository.create(r).first)).then((results) {
      if (isClosed) {
        return;
      }

      List<Result<ReportModel, Exception>> failedResults =
          results.where((r) => r.isError()).toList();
      if (failedResults.isNotEmpty) {
        emit(SaveErrorFormReportFormState(
          errorDetails: failedResults.first.tryGetError().toString(),
          brand: _brand,
          name: _name,
          availability: _availability,
          availabilityLabel: _availabilityLabel,
          addressStreet: _addressStreet,
          addressHouseNumber: _addressHouseNumber,
          addressPostCode: _addressPostCode,
          addressCity: _addressCity,
          addressCountry: _addressCountry,
          locationLatitude: _locationLatitude,
          locationLongitude: _locationLongitude,
          priceE5: _priceE5,
          priceE10: _priceE10,
          priceDiesel: _priceDiesel,
          openTimesState: _openTimesState,
          openTimesStateLabel: _openTimesStateLabel,
          openTimes: _openTimes,
          note: _note,
        ));
        return;
      }

      emit(SavedFormReportFormState(
        brand: _brand,
        name: _name,
        availability: _availability,
        availabilityLabel: _availabilityLabel,
        addressStreet: _addressStreet,
        addressHouseNumber: _addressHouseNumber,
        addressPostCode: _addressPostCode,
        addressCity: _addressCity,
        addressCountry: _addressCountry,
        locationLatitude: _locationLatitude,
        locationLongitude: _locationLongitude,
        priceE5: _priceE5,
        priceE10: _priceE10,
        priceDiesel: _priceDiesel,
        openTimesState: _openTimesState,
        openTimesStateLabel: _openTimesStateLabel,
        openTimes: _openTimes,
        note: _note,
      ));
    });
  }

  ReportModel? _createReport(
      ReportField field, String wrongValue, String correctValue) {
    if (wrongValue == correctValue) {
      return null;
    }

    return ReportModel(
      id: -1,
      stationId: stationId,
      field: field,
      wrongValue: wrongValue,
      correctValue: correctValue.trim().isNotEmpty ? correctValue : "-",
      status: ReportStatus.open,
    );
  }
}

abstract class ReportFormState {}

class LoadingReportFormState extends ReportFormState {}

class FormReportFormState extends ReportFormState {
  String name;
  String brand;
  String availability;
  String availabilityLabel;
  String addressStreet;
  String addressHouseNumber;
  String addressCity;
  String addressPostCode;
  String addressCountry;
  String locationLatitude;
  String locationLongitude;
  String priceE5;
  String priceE10;
  String priceDiesel;
  String openTimesState;
  String openTimesStateLabel;
  String openTimes;
  String note;

  FormReportFormState({
    required this.name,
    required this.brand,
    required this.availability,
    required this.availabilityLabel,
    required this.addressStreet,
    required this.addressHouseNumber,
    required this.addressCity,
    required this.addressPostCode,
    required this.addressCountry,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.priceE5,
    required this.priceE10,
    required this.priceDiesel,
    required this.openTimesState,
    required this.openTimesStateLabel,
    required this.openTimes,
    required this.note
  });
}

class ErrorReportFormState extends ReportFormState {
  String errorDetails;

  ErrorReportFormState({required this.errorDetails});
}

class SavingFormReportFormState extends FormReportFormState {
  SavingFormReportFormState({
    required super.name,
    required super.brand,
    required super.availability,
    required super.availabilityLabel,
    required super.addressStreet,
    required super.addressHouseNumber,
    required super.addressCity,
    required super.addressPostCode,
    required super.addressCountry,
    required super.locationLatitude,
    required super.locationLongitude,
    required super.priceE5,
    required super.priceE10,
    required super.priceDiesel,
    required super.openTimesState,
    required super.openTimesStateLabel,
    required super.openTimes,
    required super.note
  });
}

class SaveErrorFormReportFormState extends FormReportFormState {
  String errorDetails;

  SaveErrorFormReportFormState({
    required this.errorDetails,
    required super.name,
    required super.brand,
    required super.availability,
    required super.availabilityLabel,
    required super.addressStreet,
    required super.addressHouseNumber,
    required super.addressCity,
    required super.addressPostCode,
    required super.addressCountry,
    required super.locationLatitude,
    required super.locationLongitude,
    required super.priceE5,
    required super.priceE10,
    required super.priceDiesel,
    required super.openTimesState,
    required super.openTimesStateLabel,
    required super.openTimes,
    required super.note
  });
}

class SavedFormReportFormState extends FormReportFormState {
  SavedFormReportFormState({
    required super.name,
    required super.brand,
    required super.availability,
    required super.availabilityLabel,
    required super.addressStreet,
    required super.addressHouseNumber,
    required super.addressCity,
    required super.addressPostCode,
    required super.addressCountry,
    required super.locationLatitude,
    required super.locationLongitude,
    required super.priceE5,
    required super.priceE10,
    required super.priceDiesel,
    required super.openTimesState,
    required super.openTimesStateLabel,
    required super.openTimes,
    required super.note
  });
}

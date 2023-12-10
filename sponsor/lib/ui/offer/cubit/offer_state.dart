abstract class OfferState {}

class LoadingOfferState extends OfferState {}

class OffersOfferState extends OfferState {
  List<OfferItem> items;
  bool isSponsorshipInfoVisible;
  String sponsoredValue;
  String? activeSubscription;
  String title;

  OffersOfferState(
      {required this.items,
      required this.title,
      required this.isSponsorshipInfoVisible,
      required this.sponsoredValue,
      required this.activeSubscription});
}

class PurchasedOffersOfferState extends OffersOfferState {
  PurchasedOffersOfferState(
      {required super.items,
      required super.title,
      required super.isSponsorshipInfoVisible,
      required super.sponsoredValue,
      required super.activeSubscription});
}

class ErrorOfferState extends OfferState {
  String errorDetails;

  ErrorOfferState({required this.errorDetails});
}

class ErrorPurchaseLoadingOfferState extends LoadingOfferState {
  String? errorDetails;

  ErrorPurchaseLoadingOfferState({required this.errorDetails});
}

class OfferItem {
  String id;
  String labelPrice;
  String labelType;
  String hint;

  OfferItem(
      {required this.id,
      required this.labelPrice,
      required this.labelType,
      required this.hint});
}

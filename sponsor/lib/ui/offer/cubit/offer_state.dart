abstract class OfferState {}

class LoadingOfferState extends OfferState {}

class OffersOfferState extends OfferState {
  List<OfferItem> items;

  OffersOfferState({required this.items});
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

  OfferItem({required this.id, required this.labelPrice, required this.labelType, required this.hint});
}

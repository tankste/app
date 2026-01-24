abstract class BecomeMembershipState {}

class LoadingBecomeMembershipState extends BecomeMembershipState {}

class ErrorBecomeMembershipState extends BecomeMembershipState {}

class ProductsBecomeMembershipState extends BecomeMembershipState {
  String monthPrice;
  String yearPrice;

  ProductsBecomeMembershipState(
      {required this.monthPrice, required this.yearPrice});
}

class ProvidersBecomeMembershipState extends BecomeMembershipState {
  List<BecomeMembershipProvider> providers;

  ProvidersBecomeMembershipState({required this.providers});
}

class BoughtBecomeMembershipState extends BecomeMembershipState {}

class BecomeMembershipProvider {
  String label;
  String logoName;
  Uri url;

  BecomeMembershipProvider(
      {required this.label, required this.logoName, required this.url});
}

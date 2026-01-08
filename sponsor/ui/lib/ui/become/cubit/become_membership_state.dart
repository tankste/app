abstract class BecomeMembershipState {}

class LoadingBecomeMembershipState extends BecomeMembershipState {}

class ErrorBecomeMembershipState extends BecomeMembershipState {}

class ProductsBecomeMembershipState extends BecomeMembershipState {
  String monthPrice;
  String yearPrice;

  ProductsBecomeMembershipState({required this.monthPrice, required this.yearPrice});
}

abstract class MembershipState {}

class LoadingMembershipState extends MembershipState {}

class ErrorMembershipState extends MembershipState {}

class InfoMembershipState extends MembershipState {
  bool showSymbol;

  InfoMembershipState({required this.showSymbol});
}

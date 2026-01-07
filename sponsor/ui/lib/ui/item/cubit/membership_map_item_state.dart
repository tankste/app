
abstract class MembershipMapItemState {}

class LoadingMembershipMapItemState extends MembershipMapItemState {}

class ErrorMembershipMapItemState extends MembershipMapItemState {}

class InfoMembershipMapItemState extends MembershipMapItemState {
  bool isMember;

  InfoMembershipMapItemState({required this.isMember});
}
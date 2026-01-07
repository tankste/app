import 'package:sponsor_core/repository/membership_repository.dart';
import 'package:sponsor_ui/ui/item/cubit/membership_map_item_state.dart';
import 'package:sponsor_data_closed/repository/store_membership_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembershipMapItemCubit extends Cubit<MembershipMapItemState> {
  final MembershipRepository _membershipRepository = StoreMembershipRepository();

  MembershipMapItemCubit() : super(LoadingMembershipMapItemState()) {
    _fetchMembership();
  }

  void _fetchMembership() {
    _membershipRepository.get().listen((result) {
      if (isClosed) {
        return;
      }

      emit(result.when(
          (membership) =>
              InfoMembershipMapItemState(isMember: membership != null),
          (error) => ErrorMembershipMapItemState()));
    });
  }
}

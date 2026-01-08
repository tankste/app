import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/streams.dart';
import 'package:sponsor_core/repository/membership_repository.dart';
import 'package:sponsor_core/repository/symbol_repository.dart';
import 'package:sponsor_data_closed/repository/store_membership_repository.dart';
import 'package:sponsor_ui/ui/item/cubit/membership_map_item_state.dart';

class MembershipMapItemCubit extends Cubit<MembershipMapItemState> {
  final MembershipRepository _membershipRepository =
      StoreMembershipRepository();
  final SymbolRepository _symbolRepository = LocalSymbolRepository();

  MembershipMapItemCubit() : super(LoadingMembershipMapItemState()) {
    _fetchMembership();
  }

  void _fetchMembership() {
    CombineLatestStream.combine2(
        _membershipRepository.get(), _symbolRepository.isEnabled(),
        (membershipResult, isSymbolEnabled) {
      return membershipResult.when((membership) {
        if (membership != null && !isSymbolEnabled) {
          return HiddenMembershipMapItemState();
        } else {
          return InfoMembershipMapItemState(isMember: membership != null);
        }
      }, (error) => ErrorMembershipMapItemState());
    }).listen((state) {
      if (isClosed) {
        return;
      }

      emit(state);
    });
  }
}

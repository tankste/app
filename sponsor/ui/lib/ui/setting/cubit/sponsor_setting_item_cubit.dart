import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sponsor_core/repository/membership_repository.dart';
import 'package:sponsor_data/di/sponsor_data_module_factory.dart';
import 'package:sponsor_ui/ui/setting/cubit/sponsor_setting_item_state.dart';

class SponsorSettingItemCubit extends Cubit<SponsorSettingItemState> {
  final MembershipRepository _membershipRepository =
      SponsorDataModuleFactory.createMembershipRepository();

  SponsorSettingItemCubit() : super(LoadingSponsorSettingItemState()) {
    _fetchMembership();
  }

  void _fetchMembership() {
    _membershipRepository.get().listen((membershipResult) {
      if (isClosed) {
        return;
      }

      emit(membershipResult.when(
          (membership) =>
              InfoSponsorSettingItemState(isMember: membership != null),
          (error) => ErrorSponsorSettingItemState()));
    });
  }
}

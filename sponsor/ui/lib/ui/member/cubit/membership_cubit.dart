import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sponsor_core/repository/symbol_repository.dart';
import 'package:sponsor_ui/ui/member/cubit/membership_state.dart';

class MembershipCubit extends Cubit<MembershipState> {
  final SymbolRepository _symbolRepository = LocalSymbolRepository();

  MembershipCubit() : super(LoadingMembershipState()) {
    _fetchSymbolEnabled();
  }

  void _fetchSymbolEnabled() {
    _symbolRepository.isEnabled().listen((isEnabled) {
      if (isClosed) {
        return;
      }

      emit(InfoMembershipState(showSymbol: isEnabled));
    });
  }

  void onSymbolOptionChanged(bool isEnabled) {
    emit(InfoMembershipState(showSymbol: isEnabled));
    _symbolRepository.set(isEnabled);
  }
}

import 'dart:async';

import 'package:multiple_result/multiple_result.dart';
import 'package:sponsor_core/model/membership_model.dart';
import 'package:sponsor_core/repository/membership_repository.dart';

class FossMembershipRepository extends MembershipRepository {
  static final FossMembershipRepository _singleton =
      FossMembershipRepository._internal();

  factory FossMembershipRepository() {
    return _singleton;
  }

  FossMembershipRepository._internal();

  @override
  Stream<Result<MembershipModel?, Exception>> get() {
    return Stream.value(Result.success(null));
  }
}

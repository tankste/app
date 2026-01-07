import 'package:multiple_result/multiple_result.dart';
import 'package:sponsor_core/model/membership_model.dart';

abstract class MembershipRepository {
  Stream<Result<MembershipModel?, Exception>> get();
}
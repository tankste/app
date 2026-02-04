import 'package:review_core/util/review_helper.dart';
import 'package:review_impl/util/noop_review_helper.dart';

class ReviewImplModuleFactory {
  static ReviewHelper createReviewHelper() {
    return NoOpReviewHelper();
  }
}

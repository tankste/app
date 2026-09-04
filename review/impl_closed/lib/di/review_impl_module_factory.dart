import 'package:review_core/util/review_helper.dart';
import 'package:review_impl/util/store_review_helper.dart';

class ReviewImplModuleFactory {
  static ReviewHelper createReviewHelper() {
    return StoreReviewHelper();
  }
}

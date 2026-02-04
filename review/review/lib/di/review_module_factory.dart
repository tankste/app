import 'package:review_core/util/review_helper.dart';
import 'package:review_impl/di/review_impl_module_factory.dart';

class ReviewModuleFactory {
  static ReviewHelper createReviewHelper() {
    return ReviewImplModuleFactory.createReviewHelper();
  }
}

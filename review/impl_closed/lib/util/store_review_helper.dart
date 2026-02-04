import 'package:review_core/util/review_helper.dart';
import 'package:in_app_review/in_app_review.dart';

class StoreReviewHelper extends ReviewHelper {
  @override
  Future<void> requestReview() async {
    InAppReview inAppReview = InAppReview.instance;
    bool isReviewAvailable = await inAppReview.isAvailable();
    if (!isReviewAvailable) {
      return;
    }

    await inAppReview.requestReview();
  }
}

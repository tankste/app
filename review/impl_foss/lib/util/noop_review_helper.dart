import 'package:review_core/util/review_helper.dart';

class NoOpReviewHelper extends ReviewHelper {
  @override
  Future<void> requestReview() async {
    // Not supported
  }
}

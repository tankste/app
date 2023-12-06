import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/streams.dart';
import 'package:sponsor/di/sponsor_module_factory.dart';
import 'package:sponsor/repository/comment_repository.dart';
import 'package:sponsor/ui/comment/list/cubit/comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository _commentRepository =
      SponsorModuleFactory.createCommentRepository();

  CommentCubit() : super(LoadingCommentState()) {
    _fetchComments();
  }

  void _fetchComments() {
    emit(LoadingCommentState());

    CombineLatestStream.combine2(
        _commentRepository.list(), _commentRepository.getOwn(),
        (commentsResult, ownCommentResult) {
      return commentsResult.when((comments) {
        int? ownCommentId = ownCommentResult.tryGetSuccess()?.id;
        List<CommentItem> items = comments
            .map((c) => CommentItem(
                id: c.id,
                avatarChar: c.name.isNotEmpty ? c.name[0].toUpperCase() : "?",
                name: c.name.isNotEmpty ? c.name : "Anonym",
                comment: c.comment.isNotEmpty ? c.comment : "-",
                value: "${c.value.round()} €",
                isEditable: c.id == ownCommentId))
            .toList();

        return CommentsCommentState(items: items);
      }, (error) => ErrorCommentState(errorDetails: error.toString()));
    }).listen((state) {
      if (isClosed) {
        return;
      }

      emit(state);
    });
  }

  void onRetryClicked() {
    _fetchComments();
  }
}

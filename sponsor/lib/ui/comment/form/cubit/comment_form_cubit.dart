import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/streams.dart';
import 'package:sponsor/di/sponsor_module_factory.dart';
import 'package:sponsor/model/comment_model.dart';
import 'package:sponsor/repository/comment_repository.dart';
import 'package:sponsor/ui/comment/form/cubit/comment_form_state.dart';
import 'package:sponsor/ui/comment/list/cubit/comment_state.dart';

class CommentFormCubit extends Cubit<CommentFormState> {
  final CommentRepository _commentRepository =
      SponsorModuleFactory.createCommentRepository();

  CommentModel? comment;
  String _name = "";
  String _comment = "";

  CommentFormCubit() : super(LoadingCommentFormState()) {
    _fetchComment();
  }

  void _fetchComment() {
    emit(LoadingCommentFormState());

    _commentRepository.getOwn().first.then((result) {
      if (isClosed) {
        return;
      }

      emit(result.when((comment) {
        this.comment = comment;
        _name = comment.name;
        _comment = comment.comment;

        return FormCommentFormState(
            name: comment.name, comment: comment.comment);
      }, (error) => ErrorCommentFormState(errorDetails: error.toString())));
    });
  }

  void onRetryClicked() {
    _fetchComment();
  }

  void onNameChanged(String name) {
    _name = name;
  }

  void onCommentChanged(String comment) {
    _comment = comment;
  }

  void onSaveClicked() {
    if (comment == null) {
      return;
    }

    emit(SavingFormCommentFormState(name: _name, comment: _comment));

    _commentRepository
        .update(comment!.copyWith(name: _name, comment: _comment))
        .first
        .then((result) {
      if (isClosed) {
        return;
      }

      emit(result.when(
          (_) =>
              SavedSavingFormCommentFormState(name: _name, comment: _comment),
          (error) =>
              SaveErrorFormCommentFormState(name: _name, comment: _comment)));
    });
  }

  void onRetrySaveClicked() {
    onSaveClicked();
  }
}

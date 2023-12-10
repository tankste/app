abstract class CommentFormState {}

class LoadingCommentFormState extends CommentFormState {}

class FormCommentFormState extends CommentFormState {
  final String name;
  final String comment;

  FormCommentFormState({required this.name, required this.comment});
}

class ErrorCommentFormState extends CommentFormState {
  String errorDetails;

  ErrorCommentFormState({required this.errorDetails});
}

class SavingFormCommentFormState extends FormCommentFormState {
  SavingFormCommentFormState({required super.name, required super.comment});
}

class SaveErrorFormCommentFormState extends FormCommentFormState {
  SaveErrorFormCommentFormState({required super.name, required super.comment});
}

class SavedSavingFormCommentFormState extends SavingFormCommentFormState {
  SavedSavingFormCommentFormState({required super.name, required super.comment});
}

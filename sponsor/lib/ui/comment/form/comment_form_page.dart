import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sponsor/ui/comment/form/cubit/comment_form_cubit.dart';
import 'package:sponsor/ui/comment/form/cubit/comment_form_state.dart';

class CommentFormPage extends StatelessWidget {
  final _nameTextController = TextEditingController();
  final _commentTextController = TextEditingController();
  bool _hasInit = false;

  CommentFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CommentFormCubit(),
        child: BlocConsumer<CommentFormCubit, CommentFormState>(
            listener: (context, state) {
          if (state is SavedSavingFormCommentFormState) {
            Navigator.of(context).pop();
          } else if (state is SaveErrorFormCommentFormState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(tr('generic.error.short')),
              action: SnackBarAction(
                onPressed: () {
                  context.read<CommentFormCubit>().onRetrySaveClicked();
                },
                label: tr('generic.retry.short'),
              ),
            ));
          } else if (state is FormCommentFormState) {
            if (!_hasInit) {
              //TODO: is there a smarter way to do this?
              _nameTextController.text = state.name;
              _commentTextController.text = state.comment;
              _hasInit = true;
            }
          }
        }, builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(tr('sponsor.overview.comments.edit')),
              ),
              body: SafeArea(child: _buildBody(context, state)));
        }));
  }

  Widget _buildBody(BuildContext context, CommentFormState state) {
    if (state is LoadingCommentFormState) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator()));
    } else if (state is ErrorCommentFormState) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(children: [
            Text(tr('generic.error.title'),
                style: Theme.of(context).textTheme.headlineSmall),
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  tr('generic.error.long'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                    onPressed: () {
                      context.read<CommentFormCubit>().onRetryClicked();
                    },
                    child: Text(tr('generic.retry.short')))),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(tr('generic.error.details.title')),
                          content: Text(state.errorDetails.toString()),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(tr('generic.ok'))),
                          ],
                        );
                      });
                },
                child: Text(tr('generic.error.details.show')))
          ]));
    } else if (state is FormCommentFormState) {
      return SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: tr('generic.name'),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
                errorText: null,
              ),
              controller: _nameTextController,
              onChanged: (String text) {
                context.read<CommentFormCubit>().onNameChanged(text);
              },
            ),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: tr('sponsor.overview.comments.comment'),
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: null,
                  ),
                  minLines: 5,
                  maxLines: 5,
                  controller: _commentTextController,
                  onChanged: (String text) {
                    context.read<CommentFormCubit>().onCommentChanged(text);
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    const Spacer(),
                    state is SavingFormCommentFormState
                        ? const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )))
                        : Container(),
                    ElevatedButton(
                        onPressed: state is! SavingFormCommentFormState
                            ? () {
                                context
                                    .read<CommentFormCubit>()
                                    .onSaveClicked();
                              }
                            : null,
                        child: Text(tr('generic.save'))),
                  ],
                )),
          ],
        ),
      ));
    } else {
      return Container();
    }
  }
}

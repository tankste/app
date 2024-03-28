import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sponsor/ui/comment/form/comment_form_page.dart';
import 'package:sponsor/ui/comment/list/cubit/comment_cubit.dart';
import 'package:sponsor/ui/comment/list/cubit/comment_state.dart';

class CommentContainer extends StatelessWidget {
  const CommentContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CommentCubit(),
        child: BlocConsumer<CommentCubit, CommentState>(
            listener: (context, state) {},
            builder: (context, state) {
              return SafeArea(child: _buildBody(context, state));
            }));
  }

  Widget _buildBody(BuildContext context, CommentState state) {
    if (state is LoadingCommentState) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator()));
    } else if (state is ErrorCommentState) {
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Column(children: [
            Text(tr('generic.error.title'),
                style: Theme.of(context).textTheme.headline5),
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
                      context.read<CommentCubit>().onRetryClicked();
                    },
                    child: Text(tr('generic.retry.long')))),
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
                child: Text(tr('generic.error.details.show'))),
          ]));
    } else if (state is CommentsCommentState) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Text(tr('sponsor.overview.sponsors'),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleLarge),
        ),
        ...state.items.map((item) => Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(child: Text(item.avatarChar)),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              Text(item.comment,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ))),
                  Text(item.value,
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              item.isEditable
                  ? Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentFormPage()));
                          },
                          child: Text((tr('generic.edit')))))
                  : Container(),
            ]))),
        Center(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                    tr('sponsor.overview.comments.footer', args: ["💜💜💜💜"]),
                    style: Theme.of(context).textTheme.bodySmall)))
      ]);
    } else {
      return Container();
    }
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/ui/configuration/ui/form/configuration_form_cubit.dart';
import 'package:settings/ui/configuration/ui/form/configuration_form_state.dart';

class ConfigurationFormPage extends StatelessWidget {
  const ConfigurationFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfigurationFormCubit(),
      child: BlocConsumer<ConfigurationFormCubit, ConfigurationFormState>(
        listener: (context, state) {
          if (state is SavedConfigurationFormState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(tr('settings.app.configuration.title'))),
            body: SafeArea(child: _buildBody(context, state)),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ConfigurationFormState state) {
    if (state is LoadingConfigurationFormState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ErrorConfigurationFormState) {
      return Center(
        child: Column(
          children: [
            const Spacer(),
            Text(
              tr('generic.error.title'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                (tr('generic.error.long')),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  context.read<ConfigurationFormCubit>().onRetryClicked();
                },
                child: Text(tr('generic.retry.long')),
              ),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(tr('generic.error.details.title')),
                      content: Text(state.errorDetails),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(tr('generic.ok')),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(tr('generic.error.details.show')),
            ),
            const Spacer(),
          ],
        ),
      );
    } else if (state is FormConfigurationFormState) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 20,
            children: [
              ...state.fields.map(
                (field) => TextField(
                  onChanged: (value) {
                    context.read<ConfigurationFormCubit>().onFieldChanged(
                      field.key,
                      value,
                    );
                  },
                  controller: TextEditingController(text: field.value),
                  keyboardType: field.inputType,
                  decoration: InputDecoration(
                    labelText: field.label,
                    hintText: field.hint.toString(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: const OutlineInputBorder(),
                    errorText: field.error,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  state is SavingConfigurationFormState
                      ? const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Container(),
                  ElevatedButton(
                    onPressed: state is SavingConfigurationFormState
                        ? null
                        : () {
                            context
                                .read<ConfigurationFormCubit>()
                                .onSaveClicked();
                          },
                    child: Text(tr('generic.save')),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Container();
  }
}

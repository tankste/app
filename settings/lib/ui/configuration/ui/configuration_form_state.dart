import 'package:flutter/material.dart';

abstract class ConfigurationFormState {}

class LoadingConfigurationFormState extends ConfigurationFormState {}

abstract class FormConfigurationFormState extends ConfigurationFormState {
  final List<ConfigurationField> fields;

  FormConfigurationFormState({required this.fields});
}

class SavingConfigurationFormState extends FormConfigurationFormState {
  SavingConfigurationFormState({required super.fields});
}

class ValuesConfigurationFormState extends FormConfigurationFormState {
  ValuesConfigurationFormState({required super.fields});
}

class SavedConfigurationFormState extends SavingConfigurationFormState {
  SavedConfigurationFormState({required super.fields});
}

class ErrorConfigurationFormState extends ConfigurationFormState {
  final String errorDetails;

  ErrorConfigurationFormState({required this.errorDetails});
}

class ConfigurationField {
  String key;
  String label;
  String hint;
  String value;
  TextInputType inputType;
  String? error;

  ConfigurationField({
    required this.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.inputType,
    this.error,
  });
}

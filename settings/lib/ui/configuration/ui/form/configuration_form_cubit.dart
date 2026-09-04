import 'package:collection/collection.dart';
import 'package:core/config/config_repository.dart';
import 'package:core/config/model/configuration_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/ui/configuration/ui/form/configuration_form_state.dart';

//TODO(fabi755): allow also other types (bool) to be configurable
class ConfigurationFormCubit extends Cubit<ConfigurationFormState> {
  final ConfigRepository _configRepository =
      SettingsModuleFactory.createConfigRepository();

  List<ConfigurationModel> configurationItems = [];
  Map<String, String> values = {};

  ConfigurationFormCubit() : super(LoadingConfigurationFormState()) {
    _fetchItems();
  }

  void _fetchItems() {
    _configRepository.getAllEntries().then((result) async {
      if (isClosed) {
        return;
      }

      result.when(
        (items) {
          List<ConfigurationModel> configurableItems = items
              .where((item) => item.isConfigurable)
              .toList(growable: false);

          configurationItems = configurableItems;

          Future.wait(
            configurableItems.map(
              (item) => _configRepository
                  .getStringValue(item.key)
                  .first
                  .then((value) => MapEntry(item, value)),
            ),
          ).then((itemValues) {
            if (isClosed) {
              return;
            }

            List<ConfigurationField> fields = itemValues
                .where((itemValue) => itemValue.key.isConfigurable)
                .map((itemValue) {
                  return ConfigurationField(
                    key: itemValue.key.key,
                    label: itemValue.key.label,
                    hint: itemValue.key.defaultValue,
                    inputType: itemValue.key.type == ConfigItemType.url
                        ? TextInputType.url
                        : TextInputType.text,
                    value: itemValue.value != itemValue.key.defaultValue
                        ? itemValue.value
                        : "",
                  );
                })
                .toList();

            emit(ValuesConfigurationFormState(fields: fields));
          });
          (error) =>
              emit(ErrorConfigurationFormState(errorDetails: error.toString()));
        },
        (error) =>
            emit(ErrorConfigurationFormState(errorDetails: error.toString())),
      );
    });
  }

  void onFieldChanged(String key, String value) {
    values[key] = value;
  }

  void onSaveClicked() {
    ConfigurationFormState state = this.state;
    if (state is FormConfigurationFormState) {
      emit(SavingConfigurationFormState(fields: state.fields));

      Map<String, String?> validationErrors = values.map((key, value) {
        ConfigItemType type =
            configurationItems
                .firstWhereOrNull((configItem) => configItem.key == key)
                ?.type ??
            ConfigItemType.unspecified;

        if (value.isNotEmpty && type == ConfigItemType.url) {
          Uri? uri = Uri.tryParse(value);
          if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
            return MapEntry(key, tr('settings.app.configuration.invalid_url'));
          }
        }

        return MapEntry(key, null);
      });

      if (validationErrors.values.any((error) => error != null)) {
        List<ConfigurationField> fields = state.fields.map((field) {
          return ConfigurationField(
            key: field.key,
            label: field.label,
            hint: field.hint,
            inputType: field.inputType,
            value: values[field.key] ?? "",
            error: validationErrors[field.key],
          );
        }).toList();

        emit(ValuesConfigurationFormState(fields: fields));
        return;
      }

      Future.wait(
        values.map((key, value) {
          ConfigItemType type =
              configurationItems
                  .firstWhereOrNull((configItem) => configItem.key == key)
                  ?.type ??
              ConfigItemType.unspecified;

          // Remove ending slash from URLs
          if (type == ConfigItemType.url && value.endsWith('/')) {
            value = value.substring(0, value.length - 1);
          }

          return MapEntry(key, _configRepository.updateValue(key, value));
        }).values,
      ).then((_) => emit(SavedConfigurationFormState(fields: state.fields)));
    }
  }

  void onRetryClicked() {
    _fetchItems();
  }
}

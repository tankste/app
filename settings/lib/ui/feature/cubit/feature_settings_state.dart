
import 'package:settings/model/developer_settings_model.dart';

abstract class FeatureSettingsState {}

class LoadingFeatureSettingsState extends FeatureSettingsState {}

class FeaturesFeatureSettingsState extends FeatureSettingsState {
  final List<Feature> availableFeatures;
  final List<Feature> enabledFeatures;

  FeaturesFeatureSettingsState({required this.availableFeatures, required this.enabledFeatures});
}
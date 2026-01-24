import 'package:sponsor_core/model/provider_model.dart';
import 'package:sponsor_core/repository/provider_repository.dart';

class FossProviderRepository extends ProviderRepository {
  static final FossProviderRepository _singleton =
  FossProviderRepository._internal();

  factory FossProviderRepository() {
    return _singleton;
  }

  FossProviderRepository._internal();

  final List<ProviderModel> providers = [
    ProviderModel(id: "liberapay", name: "Liberapay", logoName: "liberapay", url: Uri.parse("https://liberapay.com/tankste/donate")),
    ProviderModel(id: "github", name: "GitHub Sponsors", logoName: "github", url: Uri.parse("https://github.com/sponsors/tankste")),
    ProviderModel(id: "buy-me-a-coffee", name: "Buy Me a Coffee", logoName: "buymeacoffee", url: Uri.parse("https://buymeacoffee.com/tankste")),
    ProviderModel(id: "ko-fi", name: "Ko-fi", logoName: "kofi", url: Uri.parse("https://ko-fi.com/tankste")),
  ];

  @override
  List<ProviderModel> list() {
    return providers;
  }
}

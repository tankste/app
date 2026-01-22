class ProviderModel {
  final String id;
  final String name;
  final String logoName;
  final Uri url;

  ProviderModel({required this.id, required this.name, required this.logoName, required this.url});

  @override
  String toString() {
    return 'ProviderModel(id: $id, name: $name, logoName: $logoName, url: $url)';
  }
}
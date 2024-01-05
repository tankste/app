class OriginModel {
  final int id;
  final String name;
  final String shortName;
  final Uri iconImageUrl;
  final Uri imageUrl;
  final Uri websiteUrl;

  OriginModel(
      {required this.id,
      required this.name,
      required this.shortName,
      required this.iconImageUrl,
      required this.imageUrl,
      required this.websiteUrl});

  @override
  String toString() {
    return 'OriginModel{id: $id, name: $name, shortName: $shortName, iconImageUrl: $iconImageUrl, imageUrl: $imageUrl, websiteUrl: $websiteUrl}';
  }
}

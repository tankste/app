class AppInfoModel {
  final String name;
  final String version;
  final String buildNumber;
  final String package;
  final String? installer;

  AppInfoModel(
      this.name, this.version, this.buildNumber, this.package, this.installer);

  String nameVersionIdentifier() {
    return "$name v$version+$buildNumber";
  }
}

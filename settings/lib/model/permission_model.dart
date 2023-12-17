
class PermissionModel {
  final bool hasRequested;

  PermissionModel({required this.hasRequested});

  PermissionModel copyWith({bool? hasRequested}) {
    return PermissionModel(
      hasRequested: hasRequested ?? this.hasRequested,
    );
  }

  @override
  String toString() {
    return 'PermissionModel{hasRequested: $hasRequested}';
  }
}
class SponsorshipModel {
  final int id;
  final String? activeSubscriptionId;
  final double value;

  SponsorshipModel(
      {required this.id,
      required this.activeSubscriptionId,
      required this.value});

  @override
  String toString() {
    return 'SponsorshipModel{id: $id, activeSubscriptionId: $activeSubscriptionId, value: $value}';
  }
}

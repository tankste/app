
abstract class SponsorSettingItemState {}

class LoadingSponsorSettingItemState extends SponsorSettingItemState {}

class ErrorSponsorSettingItemState extends SponsorSettingItemState {}

class InfoSponsorSettingItemState extends SponsorSettingItemState {
  bool isMember;

  InfoSponsorSettingItemState({required this.isMember});
}
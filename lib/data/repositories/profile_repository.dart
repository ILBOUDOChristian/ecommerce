import '../models/user_profile.dart';

class ProfileRepository {
  Future<UserProfile> fetchProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return UserProfile.mock();
  }
}

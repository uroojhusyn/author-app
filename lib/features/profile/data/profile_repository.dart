import '../../../mock_data/mock_profile.dart';
import '../../../core/services/api/api_endpoints.dart';
import '../../../core/services/api/http_api_client.dart';
import '../models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  });
}

// ─────────────────────────────────────────────────────────────
// REAL implementation — calls BlogHub /api/profile
// ─────────────────────────────────────────────────────────────
class HttpProfileRepository implements ProfileRepository {
  final HttpApiClient _api;

  HttpProfileRepository({HttpApiClient? api}) : _api = api ?? HttpApiClient();

  @override
  Future<ProfileModel> getProfile() async {
    final response = await _api.get(ApiEndpoints.profile);
    if (!response.success || response.data == null) {
      throw Exception(response.message ?? 'Failed to load profile');
    }
    final data = response.data as Map<String, dynamic>;
    return ProfileModel.fromBlogHubJson(
      (data['data'] as Map<String, dynamic>?) ?? data,
    );
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final response = await _api.put(
      ApiEndpoints.profile,
      body: profile.toBlogHubJson(),
    );
    if (!response.success || response.data == null) {
      throw Exception(response.message ?? 'Failed to update profile');
    }
    final data = response.data as Map<String, dynamic>;
    return ProfileModel.fromBlogHubJson(
      (data['data'] as Map<String, dynamic>?) ?? data,
    );
  }

  @override
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _api.post(
      ApiEndpoints.profilePassword,
      body: {
        'current_password': currentPassword,
        'password':         newPassword,
        'password_confirmation': newPassword,
      },
    );
    return response.success;
  }
}

// ─────────────────────────────────────────────────────────────
// MOCK implementation
// ─────────────────────────────────────────────────────────────
class MockProfileRepository implements ProfileRepository {
  late ProfileModel _profile;

  MockProfileRepository() {
    _profile = ProfileModel.fromJson(MockProfileData.profile);
  }

  @override
  Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _profile;
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _profile = profile;
    return _profile;
  }

  @override
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}


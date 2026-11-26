import '../../../mock_data/mock_auth.dart';
import '../../../core/services/api/api_endpoints.dart';
import '../../../core/services/api/http_api_client.dart';
import '../../../core/services/storage_service.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({required String name, required String email, required String password});
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
}

// ─────────────────────────────────────────────────────────────
// REAL implementation — calls BlogHub Laravel API
// ─────────────────────────────────────────────────────────────
class HttpAuthRepository implements AuthRepository {
  final HttpApiClient _api;
  final StorageService _storage;

  HttpAuthRepository({HttpApiClient? api, StorageService? storage})
      : _api = api ?? HttpApiClient(),
        _storage = storage ?? StorageService();

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final response = await _api.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );
    if (!response.success || response.data == null) {
      throw Exception(response.message ?? 'Login failed');
    }
    final data = Map<String, dynamic>.from(response.data as Map);
    final token = data['token'] as String?;
    if (token != null) await _storage.saveToken(token);
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      ApiEndpoints.register,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        // BlogHub requires user_type = 2 (author) on register
        'user_type': 2,
      },
    );
    if (!response.success || response.data == null) {
      throw Exception(response.message ?? 'Registration failed');
    }
    final data = Map<String, dynamic>.from(response.data as Map);
    final token = data['token'] as String?;
    if (token != null) await _storage.saveToken(token);
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final token = await _storage.getToken();
      if (token == null) return null;
      final response = await _api.get(ApiEndpoints.me);
      if (!response.success || response.data == null) return null;
      final data = Map<String, dynamic>.from(response.data as Map);
      return UserModel.fromJson(data, token: token);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    // Revoke token on server (best-effort, ignore errors)
    try {
      await _api.post(ApiEndpoints.logout);
    } catch (_) {}
    await _storage.deleteToken();
  }
}

// ─────────────────────────────────────────────────────────────
// MOCK implementation (kept for offline / UI testing)
// ─────────────────────────────────────────────────────────────
class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;

  MockAuthRepository() {
    _currentUser = _buildMock(MockAuthData.defaultAuthor);
  }

  UserModel _buildMock(Map<String, dynamic> data) => UserModel(
    id: int.tryParse(data['id'].toString()) ?? 1,
    name: data['name'] as String? ?? 'Mock Author',
    email: data['email'] as String? ?? 'mock@bloghub.com',
    avatarUrl: data['avatar'] as String?,
    bio: data['bio'] as String?,
    token: data['token'] as String?,
    userType: 2,
  );

  @override
  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = UserModel(
      id: 1,
      name: email.split('@').first,
      email: email,
      userType: 2,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      bio: 'Author at BlogHub.',
    );
    return _currentUser!;
  }

  @override
  Future<UserModel> register({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      email: email,
      userType: 2,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      bio: 'New author on BlogHub.',
    );
    return _currentUser!;
  }

  @override
  Future<UserModel?> getCurrentUser() async => _currentUser;

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}


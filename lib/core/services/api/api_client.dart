import 'api_response.dart';

/// Abstract API client contract.
/// In Phase 1, repository implementations will use mock datasets.
/// In Phase 2, a concrete HTTP/Dio implementation of this client will be plugged in
/// to interact directly with the Laravel API.
abstract class ApiClient {
  Future<ApiResponse<dynamic>> get(String endpoint, {Map<String, dynamic>? queryParams});
  Future<ApiResponse<dynamic>> post(String endpoint, {Map<String, dynamic>? body});
  Future<ApiResponse<dynamic>> put(String endpoint, {Map<String, dynamic>? body});
  Future<ApiResponse<dynamic>> delete(String endpoint, {Map<String, dynamic>? body});
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'api_endpoints.dart';
import 'api_response.dart';
import '../storage_service.dart';

/// Concrete HTTP implementation of [ApiClient].
/// Communicates with the BlogHub Laravel backend.
///
/// Every request:
///  • sets Accept: application/json  (required by Laravel to return JSON)
///  • attaches `Authorization: Bearer <token>` when one is saved
class HttpApiClient implements ApiClient {
  final http.Client _client;
  final StorageService _storage;

  HttpApiClient({http.Client? client, StorageService? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? StorageService();

  // ──────────────────────────────────────────────────
  // Header builder
  // ──────────────────────────────────────────────────
  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String endpoint, {Map<String, dynamic>? queryParams}) {
    final raw = '${ApiEndpoints.baseUrl}$endpoint';
    final uri = Uri.parse(raw);
    if (queryParams == null || queryParams.isEmpty) return uri;
    final stringParams = queryParams.map(
      (k, v) => MapEntry(k, v.toString()),
    );
    return uri.replace(queryParameters: stringParams);
  }

  // ──────────────────────────────────────────────────
  // Response parser
  // ──────────────────────────────────────────────────
  ApiResponse<dynamic> _parse(http.Response response) {
    dynamic body;
    try {
      body = json.decode(response.body);
    } catch (_) {
      body = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse.success(body);
    }

    // Laravel validation errors → 422
    if (response.statusCode == 422 && body is Map) {
      final errors = (body['errors'] as Map?)?.map(
        (k, v) => MapEntry(
          k.toString(),
          (v as List).map((e) => e.toString()).toList(),
        ),
      );
      return ApiResponse.error(
        body['message'] as String? ?? 'Validation error',
        errors,
      );
    }

    final message = (body is Map ? body['message'] : null) as String? ??
        'HTTP ${response.statusCode}';
    return ApiResponse.error(message);
  }

  // ──────────────────────────────────────────────────
  // ApiClient implementation
  // ──────────────────────────────────────────────────
  @override
  Future<ApiResponse<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _client.get(
        _uri(endpoint, queryParams: queryParams),
        headers: await _headers(),
      );
      return _parse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  @override
  Future<ApiResponse<dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client.post(
        _uri(endpoint),
        headers: await _headers(),
        body: body != null ? json.encode(body) : null,
      );
      return _parse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  @override
  Future<ApiResponse<dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client.put(
        _uri(endpoint),
        headers: await _headers(),
        body: body != null ? json.encode(body) : null,
      );
      return _parse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  @override
  Future<ApiResponse<dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client.delete(
        _uri(endpoint),
        headers: await _headers(),
        body: body != null ? json.encode(body) : null,
      );
      return _parse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Multipart POST/PUT — used for profile avatar upload.
  /// Laravel expects multipart/form-data when the client sends an image.
  Future<ApiResponse<dynamic>> multipartPost(
    String endpoint, {
    required Map<String, String> fields,
    String? filePath,
    String? fileFieldName,
    String? method, // 'PUT' for update
  }) async {
    try {
      final token = await _storage.getToken();
      final request = http.MultipartRequest(
        method ?? 'POST',
        _uri(endpoint),
      );
      request.headers['Accept'] = 'application/json';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.fields.addAll(fields);
      if (filePath != null && fileFieldName != null) {
        request.files.add(await http.MultipartFile.fromPath(
          fileFieldName,
          filePath,
        ));
      }
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      return _parse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
}

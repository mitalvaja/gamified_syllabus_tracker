import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../storage/local_storage_service.dart';
import 'api_response.dart';

class ApiClient {
  final LocalStorageService _storageService;
  final String _baseUrl;

  ApiClient({
    LocalStorageService? storageService,
    String? baseUrl,
  })  : _storageService = storageService ?? LocalStorageService(),
        _baseUrl = baseUrl ?? ApiEndpoints.baseUrl;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http.get(uri, headers: headers).timeout(
            const Duration(seconds: 5),
          );

      return _handleResponse(response, fromJson);
    } on SocketException {
      return ApiResponse.error('No internet connection / Server unreachable');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 5));

      return _handleResponse(response, fromJson);
    } on SocketException {
      return ApiResponse.error('No internet connection / Server unreachable');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http
          .put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 5));

      return _handleResponse(response, fromJson);
    } on SocketException {
      return ApiResponse.error('No internet connection / Server unreachable');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http
          .patch(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 5));

      return _handleResponse(response, fromJson);
    } on SocketException {
      return ApiResponse.error('No internet connection / Server unreachable');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http.delete(uri, headers: headers).timeout(
            const Duration(seconds: 5),
          );

      return _handleResponse(response, fromJson);
    } on SocketException {
      return ApiResponse.error('No internet connection / Server unreachable');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic data)? fromJson,
  ) {
    try {
      final decoded = jsonDecode(response.body);
      final bool isSuccess =
          response.statusCode >= 200 && response.statusCode < 300;

      if (isSuccess) {
        final data = fromJson != null && decoded['data'] != null
            ? fromJson(decoded['data'])
            : decoded['data'] as T?;
        return ApiResponse.success(
          data as T,
          message: decoded['message'],
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          decoded['message'] ?? 'An error occurred (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'Failed to parse response: ${response.body}',
        statusCode: response.statusCode,
      );
    }
  }
}

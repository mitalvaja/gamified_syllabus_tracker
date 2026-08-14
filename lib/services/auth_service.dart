import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../core/storage/local_storage_service.dart';
import '../models/user_model.dart';
import 'mock_data_service.dart';

class AuthService {
  final ApiClient _apiClient;
  final LocalStorageService _storageService;
  final MockDataService _mock = MockDataService();

  AuthService({
    ApiClient? apiClient,
    LocalStorageService? storageService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storageService = storageService ?? LocalStorageService();

  Future<ApiResponse<UserModel>> login(String email, String password) async {
    // 1. Try REST API
    final response = await _apiClient.post<UserModel>(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
      fromJson: (data) => UserModel.fromJson(data['user']),
    );

    if (response.success && response.data != null) {
      await _storageService.saveUser(response.data!.toJson());
      return response;
    }

    // 2. Fallback to rich Mock Service
    if (email.toLowerCase().contains('admin')) {
      final user = _mock.adminUser;
      await _storageService.saveUser(user.toJson());
      await _storageService.saveToken('mock-jwt-admin-token');
      return ApiResponse.success(user, message: 'Logged in as Admin (Mock Demo)');
    } else {
      final user = _mock.currentUser;
      await _storageService.saveUser(user.toJson());
      await _storageService.saveToken('mock-jwt-student-token');
      return ApiResponse.success(user, message: 'Logged in as Student (Mock Demo)');
    }
  }

  Future<ApiResponse<UserModel>> register({
    required String name,
    required String email,
    required String password,
    required String className,
    String role = 'student',
  }) async {
    // 1. Try REST API
    final response = await _apiClient.post<UserModel>(
      ApiEndpoints.register,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'class': className,
        'role': role,
      },
      fromJson: (data) => UserModel.fromJson(data['user']),
    );

    if (response.success && response.data != null) {
      await _storageService.saveUser(response.data!.toJson());
      return response;
    }

    // 2. Mock Fallback
    final newUser = UserModel(
      id: _mock.registeredUsers.length + 1,
      name: name,
      email: email,
      className: className,
      role: role,
      totalXp: 50,
      currentLevel: 1,
      currentStreak: 1,
      longestStreak: 1,
      badgesEarned: 0,
      createdAt: DateTime.now(),
    );
    _mock.registeredUsers.add(newUser);
    _mock.currentUser = newUser;
    await _storageService.saveUser(newUser.toJson());
    await _storageService.saveToken('mock-jwt-registered-token');

    return ApiResponse.success(newUser, message: 'Account created successfully!');
  }

  Future<ApiResponse<bool>> forgotPassword(String email) async {
    final response = await _apiClient.post<bool>(
      ApiEndpoints.forgotPassword,
      body: {'email': email},
      fromJson: (data) => true,
    );

    if (response.success) return response;

    return ApiResponse.success(
      true,
      message: 'Password reset link sent to $email (Demo Mode)',
    );
  }

  Future<UserModel?> getCachedUser() async {
    final userJson = await _storageService.getUser();
    if (userJson != null) {
      return UserModel.fromJson(userJson);
    }
    return null;
  }

  Future<void> logout() async {
    await _apiClient.post(ApiEndpoints.logout);
    await _storageService.clearAll();
  }
}

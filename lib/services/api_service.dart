// lib/services/api_service.dart
// ─────────────────────────────────────────────────────────────────────────────
// BACKEND INTEGRATION LAYER
// Replace BASE_URL with your actual server URL and implement the methods below.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';
import '../models/models.dart';

class ApiService {
  static const String BASE_URL = 'https://your-backend.com/api/v1';

  late final Dio _dio;
  String? _authToken;

  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;

  ApiService._() {
    _dio = Dio(BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Request interceptor — attach auth token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401) {
          // Handle token expiry — redirect to login
          _authToken = null;
        }
        return handler.next(e);
      },
    ));
  }

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuth() {
    _authToken = null;
  }

  // ── AUTH ─────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data;
    // Expected: { 'token': '...', 'user': {...} }
  }

  Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    final response = await _dio.post('/auth/signup', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
    clearAuth();
  }

  // ── R&D PUBLICATIONS ─────────────────────────────────────────────────────
  Future<List<RDPublication>> getPublications() async {
    final response = await _dio.get('/publications');
    return (response.data as List)
        .map((j) => RDPublication.fromJson(j))
        .toList();
  }

  Future<RDPublication> createPublication(RDPublication pub) async {
    final response = await _dio.post('/publications', data: pub.toJson());
    return RDPublication.fromJson(response.data);
  }

  Future<void> deletePublication(String id) async {
    await _dio.delete('/publications/$id');
  }

  // ── EXPENSES ─────────────────────────────────────────────────────────────
  Future<List<Expense>> getExpenses() async {
    final response = await _dio.get('/expenses');
    return (response.data as List)
        .map((j) => Expense.fromJson(j))
        .toList();
  }

  Future<Expense> createExpense(Expense expense) async {
    final response = await _dio.post('/expenses', data: expense.toJson());
    return Expense.fromJson(response.data);
  }

  Future<void> deleteExpense(String id) async {
    await _dio.delete('/expenses/$id');
  }

  // ── PROJECTS ─────────────────────────────────────────────────────────────
  Future<List<ClubProject>> getProjects() async {
    final response = await _dio.get('/projects');
    return (response.data as List)
        .map((j) => ClubProject.fromJson(j))
        .toList();
  }

  Future<ClubProject> createProject(ClubProject project) async {
    final response = await _dio.post('/projects', data: project.toJson());
    return ClubProject.fromJson(response.data);
  }

  Future<void> deleteProject(String id) async {
    await _dio.delete('/projects/$id');
  }

  // ── GALLERY ──────────────────────────────────────────────────────────────
  Future<List<GalleryPhoto>> getGallery() async {
    final response = await _dio.get('/gallery');
    return (response.data as List)
        .map((j) => GalleryPhoto.fromJson(j))
        .toList();
  }

  Future<GalleryPhoto> uploadPhoto(GalleryPhoto photo) async {
    final response = await _dio.post('/gallery', data: photo.toJson());
    return GalleryPhoto.fromJson(response.data);
  }

  Future<String> uploadImageFile(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post('/uploads/image', data: formData);
    return response.data['url'] as String;
  }

  Future<void> deletePhoto(String id) async {
    await _dio.delete('/gallery/$id');
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BACKEND API SPEC (for your server team):
//
// POST   /api/v1/auth/login       → { token, user }
// POST   /api/v1/auth/signup      → { token, user }
// POST   /api/v1/auth/logout      → 200
//
// GET    /api/v1/publications     → [ RDPublication ]
// POST   /api/v1/publications     → RDPublication
// DELETE /api/v1/publications/:id → 200
//
// GET    /api/v1/expenses         → [ Expense ]
// POST   /api/v1/expenses         → Expense
// DELETE /api/v1/expenses/:id     → 200
//
// GET    /api/v1/projects         → [ ClubProject ]
// POST   /api/v1/projects         → ClubProject
// DELETE /api/v1/projects/:id     → 200
//
// GET    /api/v1/gallery          → [ GalleryPhoto ]
// POST   /api/v1/gallery          → GalleryPhoto
// DELETE /api/v1/gallery/:id      → 200
// POST   /api/v1/uploads/image    → { url: string }
// ─────────────────────────────────────────────────────────────────────────────

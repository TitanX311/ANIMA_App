// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _error;
  List<AppUser> _users = [];

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  AuthProvider() {
    _loadUsers();
    _checkSession();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList('users') ?? [];
    _users = usersJson.map((j) => AppUser.fromJson(jsonDecode(j))).toList();

    // Seed demo users if empty
    if (_users.isEmpty) {
      _users = [
        AppUser(
          name: 'Arjun Sharma',
          email: 'admin@anima.aero',
          password: 'admin123',
          role: UserRole.admin,
          bio: 'Club Founder & Chief Pilot',
        ),
        AppUser(
          name: 'Priya Das',
          email: 'rd@anima.aero',
          password: 'rd123',
          role: UserRole.rdTeam,
          bio: 'Aerodynamics Researcher',
        ),
        AppUser(
          name: 'Rahul Borah',
          email: 'treasurer@anima.aero',
          password: 'treas123',
          role: UserRole.treasurer,
          bio: 'Club Treasurer & Finance Manager',
        ),
        AppUser(
          name: 'Sneha Gogoi',
          email: 'member@anima.aero',
          password: 'member123',
          role: UserRole.member,
          bio: 'Aviation Enthusiast',
        ),
      ];
      await _saveUsers();
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'users', _users.map((u) => jsonEncode(u.toJson())).toList());
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('session_user_id');
    if (userId != null) {
      await _loadUsers();
      _currentUser = _users.firstWhere(
        (u) => u.id == userId,
        orElse: () => _users.first,
      );
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800)); // simulate network

    try {
      final user = _users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
        orElse: () => throw Exception('Invalid email or password'),
      );
      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_user_id', user.id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    try {
      if (_users.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
        throw Exception('Email already registered');
      }

      final user = AppUser(
        name: name,
        email: email,
        password: password,
        role: UserRole.member,
      );
      _users.add(user);
      await _saveUsers();

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_user_id', user.id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_user_id');
    _currentUser = null;
    notifyListeners();
  }

  bool hasRole(UserRole role) {
    if (_currentUser == null) return false;
    if (_currentUser!.role == UserRole.admin) return true;
    return _currentUser!.role == role;
  }

  bool get isRDTeam => hasRole(UserRole.rdTeam);
  bool get isTreasurer => hasRole(UserRole.treasurer);
  bool get isAdmin => _currentUser?.role == UserRole.admin;
}

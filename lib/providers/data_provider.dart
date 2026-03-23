// lib/providers/data_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class DataProvider extends ChangeNotifier {
  List<RDPublication> _publications = [];
  List<Expense> _expenses = [];
  List<ClubProject> _projects = [];
  List<GalleryPhoto> _gallery = [];

  List<RDPublication> get publications => List.unmodifiable(_publications);
  List<Expense> get expenses => List.unmodifiable(_expenses);
  List<ClubProject> get projects => List.unmodifiable(_projects);
  List<GalleryPhoto> get gallery => List.unmodifiable(_gallery);

  double get totalExpenses => _expenses.fold(0, (s, e) => s + e.amount);

  Map<String, double> get expensesByCategory {
    final map = <String, double>{};
    for (final e in _expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  DataProvider() {
    _loadAll();
  }

  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    final pubsJson = prefs.getStringList('publications') ?? [];
    _publications =
        pubsJson.map((j) => RDPublication.fromJson(jsonDecode(j))).toList();

    final expsJson = prefs.getStringList('expenses') ?? [];
    _expenses = expsJson.map((j) => Expense.fromJson(jsonDecode(j))).toList();

    final projsJson = prefs.getStringList('projects') ?? [];
    _projects =
        projsJson.map((j) => ClubProject.fromJson(jsonDecode(j))).toList();

    final galleryJson = prefs.getStringList('gallery') ?? [];
    _gallery =
        galleryJson.map((j) => GalleryPhoto.fromJson(jsonDecode(j))).toList();

    // Seed demo data if empty
    if (_publications.isEmpty) await _seedData();

    notifyListeners();
  }

  Future<void> _seedData() async {
    _publications = [
      RDPublication(
        title: 'Aerodynamic Optimization of Low-Speed UAV Wings',
        abstract:
            'This paper presents a comprehensive study on wing profile optimization for sub-200g UAV platforms, achieving 23% efficiency gain.',
        content:
            '''Introduction\nWing design is critical for efficient UAV operation. Our research focused on optimizing NACA profiles for low Reynolds number flight regimes...\n\nMethodology\nWe conducted CFD simulations using OpenFOAM across 12 wing profiles...\n\nResults\nThe NACA 4412 modified profile showed optimal lift-to-drag ratio of 18.4 at 15m/s cruise speed.\n\nConclusion\nSignificant improvements in endurance were achieved through careful profile selection and wingtip modification.''',
        authorId: 'seed',
        authorName: 'Priya Das',
        tags: ['UAV', 'Aerodynamics', 'CFD', 'Wing Design'],
      ),
      RDPublication(
        title: 'Electric Propulsion System Analysis for Club Aircraft',
        abstract:
            'Comparative analysis of brushless motor configurations for the ANIMA club fleet, covering efficiency, cost, and performance metrics.',
        content:
            '''Overview\nElectric propulsion offers significant advantages for club operations including reduced noise, lower maintenance, and cleaner operation...\n\nTest Configurations\nFive motor-ESC-propeller combinations were bench tested...\n\nFindings\nThe T-Motor F90-1300KV with 5x4.5 folding prop delivered optimal efficiency at 89.3%.\n\nRecommendations\nTransition to electric fleet recommended with phased implementation over 24 months.''',
        authorId: 'seed',
        authorName: 'Arjun Sharma',
        tags: ['Electric', 'Propulsion', 'Motors', 'Efficiency'],
      ),
    ];

    _expenses = [
      Expense(
        title: 'Annual Field Permit Renewal',
        amount: 15000,
        category: ExpenseCategory.events,
        addedById: 'seed',
        addedByName: 'Rahul Borah',
        notes: 'Dibrugarh Flying Field - FY2024',
        date: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Expense(
        title: 'Lipo Battery Pack (6S 5000mAh)',
        amount: 8500,
        category: ExpenseCategory.equipment,
        addedById: 'seed',
        addedByName: 'Rahul Borah',
        date: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Expense(
        title: 'Propeller Set - Carbon Fiber',
        amount: 3200,
        category: ExpenseCategory.maintenance,
        addedById: 'seed',
        addedByName: 'Rahul Borah',
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Expense(
        title: 'FPV Racing Training Workshop',
        amount: 5000,
        category: ExpenseCategory.training,
        addedById: 'seed',
        addedByName: 'Rahul Borah',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    _projects = [
      ClubProject(
        planeName: 'Brahmaputra Mk.I',
        type: 'Fixed Wing',
        description:
            'Our flagship club trainer aircraft. Built from scratch using foam board construction with fiberglass reinforced control surfaces. Perfect for beginners.',
        imageUrls: [
          'https://images.unsplash.com/photo-1540962351504-03099e0a754b?w=800',
          'https://images.unsplash.com/photo-1474302770737-173ee21bab63?w=800',
        ],
        addedById: 'seed',
        addedByName: 'Arjun Sharma',
        status: 'Active',
        specs: {
          'Wingspan': '1400mm',
          'Weight': '1.2kg',
          'Motor': 'Sunnysky X2216',
          'Flight Time': '18 min',
          'Range': '1.5km',
        },
      ),
      ClubProject(
        planeName: 'Kingfisher FPV',
        type: 'FPV Racer',
        description:
            'High-performance FPV racing quad built for speed. Features carbon fiber frame, digital video transmission, and tuned PID controllers.',
        imageUrls: [
          'https://images.unsplash.com/photo-1507582020474-9a35b7d455d9?w=800',
        ],
        addedById: 'seed',
        addedByName: 'Sneha Gogoi',
        status: 'Active',
        specs: {
          'Frame': '5" 220mm',
          'Motors': 'T-Motor F90 1300KV',
          'FC': 'Betaflight F7',
          'Weight': '680g',
          'Top Speed': '120 km/h',
        },
      ),
    ];

    _gallery = [
      GalleryPhoto(
        imageUrl:
            'https://images.unsplash.com/photo-1540962351504-03099e0a754b?w=800',
        title: 'Annual Airshow 2024',
        description: 'Club members at the AGARTALA Airshow',
        uploadedById: 'seed',
        uploadedByName: 'Arjun Sharma',
        tags: ['Airshow', 'Event'],
      ),
      GalleryPhoto(
        imageUrl:
            'https://images.unsplash.com/photo-1474302770737-173ee21bab63?w=800',
        title: 'Morning Flight Session',
        description: 'Early morning training at our field',
        uploadedById: 'seed',
        uploadedByName: 'Sneha Gogoi',
        tags: ['Training', 'Morning'],
      ),
      GalleryPhoto(
        imageUrl:
            'https://images.unsplash.com/photo-1507582020474-9a35b7d455d9?w=800',
        title: 'FPV Racing Practice',
        description: 'Kingfisher on a practice run',
        uploadedById: 'seed',
        uploadedByName: 'Priya Das',
        tags: ['FPV', 'Racing'],
      ),
      GalleryPhoto(
        imageUrl:
            'https://images.unsplash.com/photo-1566618501882-4f0e0b0b0b6e?w=800',
        title: 'Workshop Build Day',
        description: 'Team building Brahmaputra Mk.II',
        uploadedById: 'seed',
        uploadedByName: 'Rahul Borah',
        tags: ['Workshop', 'Build'],
      ),
    ];

    await _saveAll();
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('publications',
        _publications.map((p) => jsonEncode(p.toJson())).toList());
    await prefs.setStringList(
        'expenses', _expenses.map((e) => jsonEncode(e.toJson())).toList());
    await prefs.setStringList(
        'projects', _projects.map((p) => jsonEncode(p.toJson())).toList());
    await prefs.setStringList(
        'gallery', _gallery.map((g) => jsonEncode(g.toJson())).toList());
  }

  // Publications
  Future<void> addPublication(RDPublication pub) async {
    _publications.insert(0, pub);
    await _saveAll();
    notifyListeners();
  }

  Future<void> deletePublication(String id) async {
    _publications.removeWhere((p) => p.id == id);
    await _saveAll();
    notifyListeners();
  }

  // Expenses
  Future<void> addExpense(Expense expense) async {
    _expenses.insert(0, expense);
    await _saveAll();
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    await _saveAll();
    notifyListeners();
  }

  // Projects
  Future<void> addProject(ClubProject project) async {
    _projects.insert(0, project);
    await _saveAll();
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
    await _saveAll();
    notifyListeners();
  }

  // Gallery
  Future<void> addGalleryPhoto(GalleryPhoto photo) async {
    _gallery.insert(0, photo);
    await _saveAll();
    notifyListeners();
  }

  Future<void> deleteGalleryPhoto(String id) async {
    _gallery.removeWhere((g) => g.id == id);
    await _saveAll();
    notifyListeners();
  }
}

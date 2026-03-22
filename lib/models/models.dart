// lib/models/models.dart
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

enum UserRole { member, rdTeam, treasurer, admin }

class AppUser {
  final String id;
  final String name;
  final String email;
  final String password; // hashed in production
  final UserRole role;
  final String? avatarUrl;
  final String? bio;
  final DateTime joinedAt;

  AppUser({
    String? id,
    required this.name,
    required this.email,
    required this.password,
    this.role = UserRole.member,
    this.avatarUrl,
    this.bio,
    DateTime? joinedAt,
  })  : id = id ?? _uuid.v4(),
        joinedAt = joinedAt ?? DateTime.now();

  AppUser copyWith({
    String? name,
    String? email,
    UserRole? role,
    String? avatarUrl,
    String? bio,
  }) =>
      AppUser(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password,
        role: role ?? this.role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        bio: bio ?? this.bio,
        joinedAt: joinedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'role': role.name,
        'avatarUrl': avatarUrl,
        'bio': bio,
        'joinedAt': joinedAt.toIso8601String(),
      };

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'],
        name: j['name'],
        email: j['email'],
        password: j['password'],
        role: UserRole.values.firstWhere((r) => r.name == j['role'],
            orElse: () => UserRole.member),
        avatarUrl: j['avatarUrl'],
        bio: j['bio'],
        joinedAt: DateTime.parse(j['joinedAt']),
      );
}

class RDPublication {
  final String id;
  final String title;
  final String abstract;
  final String content;
  final String authorId;
  final String authorName;
  final List<String> tags;
  final List<String> attachments;
  final DateTime publishedAt;
  final int likes;

  RDPublication({
    String? id,
    required this.title,
    required this.abstract,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.tags = const [],
    this.attachments = const [],
    DateTime? publishedAt,
    this.likes = 0,
  })  : id = id ?? _uuid.v4(),
        publishedAt = publishedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'abstract': abstract,
        'content': content,
        'authorId': authorId,
        'authorName': authorName,
        'tags': tags,
        'attachments': attachments,
        'publishedAt': publishedAt.toIso8601String(),
        'likes': likes,
      };

  factory RDPublication.fromJson(Map<String, dynamic> j) => RDPublication(
        id: j['id'],
        title: j['title'],
        abstract: j['abstract'],
        content: j['content'],
        authorId: j['authorId'],
        authorName: j['authorName'],
        tags: List<String>.from(j['tags'] ?? []),
        attachments: List<String>.from(j['attachments'] ?? []),
        publishedAt: DateTime.parse(j['publishedAt']),
        likes: j['likes'] ?? 0,
      );
}

class ExpenseCategory {
  static const fuel = 'Fuel';
  static const maintenance = 'Maintenance';
  static const equipment = 'Equipment';
  static const events = 'Events';
  static const training = 'Training';
  static const misc = 'Miscellaneous';

  static const all = [fuel, maintenance, equipment, events, training, misc];
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String addedById;
  final String addedByName;
  final String? notes;
  final String? receiptUrl;
  final DateTime date;

  Expense({
    String? id,
    required this.title,
    required this.amount,
    required this.category,
    required this.addedById,
    required this.addedByName,
    this.notes,
    this.receiptUrl,
    DateTime? date,
  })  : id = id ?? _uuid.v4(),
        date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category,
        'addedById': addedById,
        'addedByName': addedByName,
        'notes': notes,
        'receiptUrl': receiptUrl,
        'date': date.toIso8601String(),
      };

  factory Expense.fromJson(Map<String, dynamic> j) => Expense(
        id: j['id'],
        title: j['title'],
        amount: (j['amount'] as num).toDouble(),
        category: j['category'],
        addedById: j['addedById'],
        addedByName: j['addedByName'],
        notes: j['notes'],
        receiptUrl: j['receiptUrl'],
        date: DateTime.parse(j['date']),
      );
}

class ClubProject {
  final String id;
  final String planeName;
  final String type;
  final String description;
  final List<String> imageUrls;
  final String addedById;
  final String addedByName;
  final String status;
  final DateTime createdAt;
  final Map<String, String> specs;

  ClubProject({
    String? id,
    required this.planeName,
    required this.type,
    required this.description,
    this.imageUrls = const [],
    required this.addedById,
    required this.addedByName,
    this.status = 'Active',
    DateTime? createdAt,
    this.specs = const {},
  })  : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'planeName': planeName,
        'type': type,
        'description': description,
        'imageUrls': imageUrls,
        'addedById': addedById,
        'addedByName': addedByName,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'specs': specs,
      };

  factory ClubProject.fromJson(Map<String, dynamic> j) => ClubProject(
        id: j['id'],
        planeName: j['planeName'],
        type: j['type'],
        description: j['description'],
        imageUrls: List<String>.from(j['imageUrls'] ?? []),
        addedById: j['addedById'],
        addedByName: j['addedByName'],
        status: j['status'],
        createdAt: DateTime.parse(j['createdAt']),
        specs: Map<String, String>.from(j['specs'] ?? {}),
      );
}

class GalleryPhoto {
  final String id;
  final String imageUrl;
  final String title;
  final String? description;
  final String uploadedById;
  final String uploadedByName;
  final DateTime uploadedAt;
  final List<String> tags;

  GalleryPhoto({
    String? id,
    required this.imageUrl,
    required this.title,
    this.description,
    required this.uploadedById,
    required this.uploadedByName,
    DateTime? uploadedAt,
    this.tags = const [],
  })  : id = id ?? _uuid.v4(),
        uploadedAt = uploadedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageUrl': imageUrl,
        'title': title,
        'description': description,
        'uploadedById': uploadedById,
        'uploadedByName': uploadedByName,
        'uploadedAt': uploadedAt.toIso8601String(),
        'tags': tags,
      };

  factory GalleryPhoto.fromJson(Map<String, dynamic> j) => GalleryPhoto(
        id: j['id'],
        imageUrl: j['imageUrl'],
        title: j['title'],
        description: j['description'],
        uploadedById: j['uploadedById'],
        uploadedByName: j['uploadedByName'],
        uploadedAt: DateTime.parse(j['uploadedAt']),
        tags: List<String>.from(j['tags'] ?? []),
      );
}

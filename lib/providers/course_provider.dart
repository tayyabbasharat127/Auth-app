import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../models/course_model.dart';
import '../repositories/course_repository.dart';

enum CourseStatus { initial, loading, success, error, empty }

class CourseProvider extends ChangeNotifier {
  final CourseRepository _repository;

  CourseProvider({CourseRepository? repository})
      : _repository = repository ?? CourseRepository();

  List<CourseModel> _courses = [];
  CourseStatus _status = CourseStatus.initial;
  String? _errorMessage;
  int? _busyCourseId;
  bool _isOffline = false;
  String _searchQuery = '';

  // ── Getters ──────────────────────────────────────────────────────────────

  List<CourseModel> get courses {
    if (_searchQuery.isEmpty) return List.unmodifiable(_courses);
    final q = _searchQuery.toLowerCase();
    return _courses
        .where((c) =>
            c.title.toLowerCase().contains(q) ||
            c.description.toLowerCase().contains(q))
        .toList();
  }

  CourseStatus get status => _status;
  String? get errorMessage => _errorMessage;
  int? get busyCourseId => _busyCourseId;
  bool get isOffline => _isOffline;
  bool get isLoading => _status == CourseStatus.loading;
  String get searchQuery => _searchQuery;

  // ── Search ────────────────────────────────────────────────────────────────

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadCourses() async {
    _status = CourseStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final results = await Connectivity().checkConnectivity();
    _isOffline = !results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet);

    try {
      final fetched = await _repository.fetchCourses();
      _courses = fetched;
      _status = fetched.isEmpty ? CourseStatus.empty : CourseStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _status = CourseStatus.error;
    }
    notifyListeners();
  }

  // ── Add (optimistic) ──────────────────────────────────────────────────────

  Future<bool> addCourse({
    required String title,
    required String description,
  }) async {
    // Place a placeholder at the top immediately.
    final tempId = -DateTime.now().millisecondsSinceEpoch;
    final optimistic = CourseModel(
      id: tempId,
      userId: 1,
      title: title,
      description: description,
    );
    _courses = [optimistic, ..._courses];
    _status = CourseStatus.success;
    notifyListeners();

    try {
      final created = await _repository.addCourse(
        title: title,
        description: description,
      );
      // Replace placeholder with the real response, keeping display name.
      _courses = _courses
          .map((c) => c.id == tempId
              ? created.copyWith(title: title, description: description)
              : c)
          .toList();
      notifyListeners();
      return true;
    } catch (e) {
      // Rollback on failure.
      _courses = _courses.where((c) => c.id != tempId).toList();
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Update (optimistic) ───────────────────────────────────────────────────

  Future<bool> updateCourse(CourseModel updated) async {
    final original = _courses.firstWhere((c) => c.id == updated.id);
    _courses = _courses.map((c) => c.id == updated.id ? updated : c).toList();
    _busyCourseId = updated.id;
    notifyListeners();

    try {
      await _repository.updateCourse(updated);
      _busyCourseId = null;
      notifyListeners();
      return true;
    } catch (e) {
      // Rollback on failure.
      _courses =
          _courses.map((c) => c.id == original.id ? original : c).toList();
      _busyCourseId = null;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Delete (optimistic) ───────────────────────────────────────────────────

  Future<bool> deleteCourse(int id) async {
    final removed = _courses.firstWhere((c) => c.id == id);
    final index = _courses.indexOf(removed);
    _courses = _courses.where((c) => c.id != id).toList();
    _busyCourseId = id;
    notifyListeners();

    try {
      await _repository.deleteCourse(id);
      _busyCourseId = null;
      if (_courses.isEmpty) _status = CourseStatus.empty;
      notifyListeners();
      return true;
    } catch (e) {
      // Rollback on failure: re-insert at original position.
      final restored = List<CourseModel>.from(_courses)..insert(index, removed);
      _courses = restored;
      _busyCourseId = null;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

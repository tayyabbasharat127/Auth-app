import 'package:connectivity_plus/connectivity_plus.dart';

import '../local/course_local_datasource.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService _api;
  final CourseLocalDataSource _local;

  CourseRepository({
    CourseService? api,
    CourseLocalDataSource? local,
  })  : _api = api ?? CourseService(),
        _local = local ?? CourseLocalDataSource();

  Future<bool> get _isOnline async {
    final results = await Connectivity().checkConnectivity();
    return !results.every((r) => r == ConnectivityResult.none);
  }

  /// Fetches courses from the API when online and caches them locally.
  /// Falls back to cached data when offline or when the API call fails.
  Future<List<CourseModel>> fetchCourses() async {
    if (await _isOnline) {
      try {
        final courses = await _api.fetchCourses();
        await _local.cacheCourses(courses);
        return courses;
      } catch (_) {
        return _local.getCachedCourses();
      }
    }
    return _local.getCachedCourses();
  }

  Future<CourseModel> addCourse({
    required String title,
    required String description,
  }) =>
      _api.addCourse(title: title, description: description);

  Future<CourseModel> updateCourse(CourseModel course) =>
      _api.updateCourse(course);

  Future<void> deleteCourse(int id) => _api.deleteCourse(id);
}

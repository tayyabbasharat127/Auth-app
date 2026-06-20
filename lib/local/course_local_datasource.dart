import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/course_model.dart';

class CourseLocalDataSource {
  static const String _boxName = 'courses_cache';
  static const String _cacheKey = 'cached_courses';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  Future<void> cacheCourses(List<CourseModel> courses) async {
    final box = Hive.box(_boxName);
    await box.put(
      _cacheKey,
      jsonEncode(courses.map((c) => c.toJson()).toList()),
    );
  }

  Future<List<CourseModel>> getCachedCourses() async {
    final box = Hive.box(_boxName);
    final raw = box.get(_cacheKey);
    if (raw == null) return [];
    final list = jsonDecode(raw as String) as List<dynamic>;
    return list
        .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course_model.dart';

class CourseService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client _client;

  CourseService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<CourseModel>> fetchCourses() async {
    final response = await _send('GET', '/posts?_limit=4');
    final decoded = jsonDecode(response) as List<dynamic>;

    return decoded
        .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
        .map(_withCourseDisplayName)
        .toList();
  }

  Future<CourseModel> addCourse({
    required String title,
    required String description,
  }) async {
    final response = await _send(
      'POST',
      '/posts',
      body: {
        'userId': 1,
        'title': title,
        'body': description,
      },
    );

    return CourseModel.fromJson(jsonDecode(response) as Map<String, dynamic>);
  }

  Future<CourseModel> updateCourse(CourseModel course) async {
    // JSONPlaceholder only has posts 1-100; IDs above that are locally created
    // and don't exist on the server, so skip the network call for those.
    if (course.id > 100) return course;
    final response = await _send(
      'PUT',
      '/posts/${course.id}',
      body: course.toJson(),
    );

    return CourseModel.fromJson(jsonDecode(response) as Map<String, dynamic>);
  }

  Future<void> deleteCourse(int id) async {
    if (id > 100) return; // Locally created — no server record to delete
    await _send('DELETE', '/posts/$id');
  }

  Future<String> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = {'Accept': 'application/json'};
    http.Response response;

    switch (method) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
        break;
      case 'POST':
        response = await _client.post(
          uri,
          headers: {...headers, 'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
        break;
      case 'PUT':
        response = await _client.put(
          uri,
          headers: {...headers, 'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
        break;
      case 'DELETE':
        response = await _client.delete(uri, headers: headers);
        break;
      default:
        throw const CourseApiException('Unsupported request method.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CourseApiException(
        'Request failed with status ${response.statusCode}.',
      );
    }

    return response.body;
  }

  CourseModel _withCourseDisplayName(CourseModel course) {
    final displayCourse = _displayCourses[course.id];
    if (displayCourse == null) return course;

    return course.copyWith(
      title: displayCourse.title,
      description: displayCourse.description,
    );
  }
}

class CourseApiException implements Exception {
  final String message;

  const CourseApiException(this.message);

  @override
  String toString() => message;
}

class _CourseDisplayData {
  final String title;
  final String description;

  const _CourseDisplayData({
    required this.title,
    required this.description,
  });
}

const Map<int, _CourseDisplayData> _displayCourses = {
  1: _CourseDisplayData(
    title: 'Mobile App Development',
    description:
        'Build cross-platform mobile apps with Flutter, Dart, navigation, forms, and REST API integration.',
  ),
  2: _CourseDisplayData(
    title: 'Software Re-engineering',
    description:
        'Analyze, refactor, and modernize existing software systems using clean engineering practices.',
  ),
  3: _CourseDisplayData(
    title: 'Management Information Systems',
    description:
        'Study how organizations use information systems for operations, reporting, and decision-making.',
  ),
  4: _CourseDisplayData(
    title: 'Database Management Systems',
    description:
        'Design relational databases, write SQL queries, and understand data modeling concepts.',
  ),
};

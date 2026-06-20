import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course_model.dart';

class CourseService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client _client;

  CourseService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<CourseModel>> fetchCourses() async {
    final response = await _send('GET', '/posts');
    final decoded = jsonDecode(response) as List<dynamic>;

    return decoded
        .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
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
    final response = await _send(
      'PUT',
      '/posts/${course.id}',
      body: course.toJson(),
    );

    return CourseModel.fromJson(jsonDecode(response) as Map<String, dynamic>);
  }

  Future<void> deleteCourse(int id) async {
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
}

class CourseApiException implements Exception {
  final String message;

  const CourseApiException(this.message);

  @override
  String toString() => message;
}

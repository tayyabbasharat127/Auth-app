import 'dart:convert';
import 'dart:io';

import '../models/course_model.dart';

class CourseService {
  static const String _baseUrl = 'jsonplaceholder.typicode.com';
  final HttpClient _client;

  CourseService({HttpClient? client}) : _client = client ?? HttpClient();

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
    final uri = Uri.https(_baseUrl, path);
    final request = await _client.openUrl(method, uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');

    if (body != null) {
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(body));
    }

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CourseApiException(
        'Request failed with status ${response.statusCode}.',
      );
    }

    return responseBody;
  }
}

class CourseApiException implements Exception {
  final String message;

  const CourseApiException(this.message);

  @override
  String toString() => message;
}

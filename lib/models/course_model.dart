class CourseModel {
  final int id;
  final int userId;
  final String title;
  final String description;

  const CourseModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      userId: json['userId'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      description: json['body'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': description,
    };
  }

  CourseModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
  }) {
    return CourseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

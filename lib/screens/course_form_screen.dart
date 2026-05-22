import 'package:flutter/material.dart';

import '../models/course_model.dart';
import '../widgets/app_text_field.dart';

class CourseFormScreen extends StatefulWidget {
  final CourseModel? course;

  const CourseFormScreen({super.key, this.course});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;

  bool get _isEditing => widget.course != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.course?.title ?? '');
    _descriptionCtrl = TextEditingController(
      text: widget.course?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  String? _required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final current = widget.course;
    final course = CourseModel(
      id: current?.id ?? 0,
      userId: current?.userId ?? 1,
      title: _titleCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
    );

    Navigator.of(context).pop(course);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Course' : 'Add Course'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _titleCtrl,
                  label: 'Course Title',
                  validator: (value) => _required(value, 'Course title'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionCtrl,
                  minLines: 5,
                  maxLines: 8,
                  textInputAction: TextInputAction.newline,
                  validator: (value) => _required(value, 'Description'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: Icon(_isEditing ? Icons.save : Icons.add),
                  label: Text(_isEditing ? 'Save Changes' : 'Add Course'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

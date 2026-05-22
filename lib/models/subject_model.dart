/// Enum for subject categories
enum SubjectCategory { mobileDev, softwareEngineering, management }

/// Subject data model
class SubjectModel {
  final String name;
  final String code;
  final String description;
  final String schedule;
  final String room;
  final SubjectCategory category;

  const SubjectModel({
    required this.name,
    required this.code,
    required this.description,
    required this.schedule,
    required this.room,
    required this.category,
  });
}

/// Static list of subjects shown on the dashboard
final List<SubjectModel> appSubjects = [
  SubjectModel(
    name: 'Mobile App Development',
    code: 'MAD401',
    description:
        'This course covers the fundamentals of building cross-platform mobile applications '
        'using Flutter and Dart. Topics include UI design, state management, navigation, '
        'REST API integration, and publishing to app stores.',
    schedule: 'Monday & Wednesday, 10:00 AM – 11:30 AM',
    room: 'Lab 3, Building B',
    category: SubjectCategory.mobileDev,
  ),
  SubjectModel(
    name: 'Software Re-engineering',
    code: 'SRE302',
    description:
        'Explores techniques for analyzing, restructuring, and modernizing legacy software '
        'systems. Topics include reverse engineering, refactoring, migration strategies, '
        'and quality assurance for re-engineered systems.',
    schedule: 'Tuesday & Thursday, 1:00 PM – 2:30 PM',
    room: 'Room 201, Building A',
    category: SubjectCategory.softwareEngineering,
  ),
  SubjectModel(
    name: 'Management Information Systems (MIS)',
    code: 'MIS201',
    description:
        'Introduces the role of information systems in organizational decision-making. '
        'Topics include database management, ERP systems, business intelligence, '
        'and IT governance frameworks.',
    schedule: 'Friday, 9:00 AM – 12:00 PM',
    room: 'Room 105, Building C',
    category: SubjectCategory.management,
  ),
];

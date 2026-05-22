/// Enum for gender selection
enum Gender { male, female, other }

/// Enum for authentication state
enum AuthState { unauthenticated, loading, authenticated, error }

/// User data model
class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final Gender gender;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get genderLabel {
    switch (gender) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

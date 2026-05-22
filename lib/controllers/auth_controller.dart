import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Handles authentication business logic — registration, login, logout, session.
class AuthController {
  // In-memory store simulating a user database (single registered user)
  static UserModel? _registeredUser;
  static String? _registeredPassword;

  /// Registers a new user. Returns null on success, or an error message.
  Future<String?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required Gender gender,
  }) async {
    // Simulate async work (e.g., network call)
    await Future.delayed(const Duration(milliseconds: 400));

    _registeredUser = UserModel(
      firstName: firstName,
      lastName: lastName,
      email: email.trim().toLowerCase(),
      gender: gender,
    );
    _registeredPassword = password;

    return null; // success
  }

  /// Logs in with [email] and [password].
  /// Returns the [UserModel] on success, or throws a [String] error message.
  Future<UserModel> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (_registeredUser == null) {
      throw 'No account found. Please register first.';
    }

    final emailMatch =
        _registeredUser!.email == email.trim().toLowerCase();
    final passwordMatch = _registeredPassword == password;

    if (!emailMatch || !passwordMatch) {
      throw 'Invalid email or password.';
    }

    if (rememberMe) {
      await _persistSession(_registeredUser!);
    } else {
      await _clearSession();
    }

    return _registeredUser!;
  }

  /// Logs out and clears any persisted session.
  Future<void> logout() async {
    await _clearSession();
  }

  Future<void> _persistSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', true);
    await prefs.setString('saved_email', user.email);
    await prefs.setString('saved_first_name', user.firstName);
    await prefs.setString('saved_last_name', user.lastName);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_me');
    await prefs.remove('saved_email');
    await prefs.remove('saved_first_name');
    await prefs.remove('saved_last_name');
  }
}

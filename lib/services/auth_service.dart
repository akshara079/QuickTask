import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService {
  Future<ParseUser?> login(String username, String password) async {
    final user = ParseUser(username, password, null);
    final response = await user.login();
    return response.success ? user : null;
  }

  Future<bool> signUp(String username, String password, String email) async {
    final user = ParseUser(username, password, email);
    final response = await user.signUp();
    return response.success;
  }

  Future<void> logout() async {
    final user = await ParseUser.currentUser();
    if (user != null) {
      await user.logout();
    }
  }
}

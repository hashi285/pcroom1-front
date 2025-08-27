import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, String?>(
      (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<String?> {
  AuthNotifier() : super(null);

  Future<void> login(String token) async {
    state = token;
  }

  Future<void> logout() async {
    state = null;
  }

  bool get isLoggedIn => state != null;
}

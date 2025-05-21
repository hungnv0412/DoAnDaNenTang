import 'package:flutter/material.dart';
import '../../domain/use_cases/sign_in_use_case.dart';

class SignInViewModel extends ChangeNotifier {
  final SignInUseCase signInUseCase;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SignInViewModel({required this.signInUseCase});

  Future<bool> signIn() async {
    _setLoading(true);
    _errorMessage = null;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    try {
      final result = await signInUseCase(email, password);
      return result;
    } catch (e) {
      _errorMessage = "Đăng nhập thất bại";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import '../../domain/use_cases/sign_up_use_case.dart';

class SignUpViewModel extends ChangeNotifier {
  final SignUpUseCase signUpUseCase;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SignUpViewModel({required this.signUpUseCase});

  Future<bool> signUp() async {
    _setLoading(true);
    _errorMessage = null;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      _errorMessage = "Mật khẩu không khớp";
      _setLoading(false);
      return false;
    }

    try {
      final result = await signUpUseCase(email, password);
      return result;
    } catch (e) {
      _errorMessage = "Đăng ký thất bại";
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
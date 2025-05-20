import 'package:flutter/material.dart';
import '../../domain/use_cases/sign_up_use_case.dart';

class SignUpViewModel extends ChangeNotifier {
  final SignUpUseCase signUpUseCase;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  SignUpViewModel({required this.signUpUseCase});

  Future<bool> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      return false;
    }

    return await signUpUseCase(email, password);
  }
}

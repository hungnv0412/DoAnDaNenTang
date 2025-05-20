import 'package:flutter/material.dart';
import '../../domain/use_cases/sign_in_use_case.dart';

class SignInViewModel extends ChangeNotifier {
  final SignInUseCase signInUseCase;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInViewModel({required this.signInUseCase});

  Future<bool> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    return await signInUseCase(email, password);
  }
}

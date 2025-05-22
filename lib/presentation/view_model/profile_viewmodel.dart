import 'package:flutter/material.dart';
import 'package:my_app/domain/use_cases/sign_out_use_case.dart';

class ProfileViewmodel extends ChangeNotifier {
  final SignOutUseCase signOutUseCase;
  ProfileViewmodel({required this.signOutUseCase});
  Future<void> signOut() async {
    try {
      await signOutUseCase.call();
      print("Đăng xuất thành công");
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
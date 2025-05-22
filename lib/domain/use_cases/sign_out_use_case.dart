import 'package:my_app/domain/repositories/user_repository.dart';

class SignOutUseCase {
  final UserRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.signOut();
  }
}
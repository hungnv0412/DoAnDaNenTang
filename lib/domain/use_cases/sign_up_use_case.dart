import '../repositories/user_repository.dart';

class SignUpUseCase {
  final UserRepository repository;

  SignUpUseCase(this.repository);

  Future<bool> call(String email, String password) async {
    return await repository.signUp(email, password);
  }
}

import '../repositories/user_repository.dart';

class SignInUseCase {
  final UserRepository repository;

  SignInUseCase(this.repository);

  Future<bool> call(String email, String password) async {
    return await repository.signIn(email, password);
  }
}

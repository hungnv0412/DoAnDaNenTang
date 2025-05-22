
abstract class UserRepository {
  Future<String> getUserName();
  Future<bool> signIn(String email, String password);
  Future<bool> signUp(String email, String password);
  Future<bool> signOut();
}
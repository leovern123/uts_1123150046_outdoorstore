abstract class AuthRepository {
  /// Verifikasi Firebase token ke backend Golang
  /// Backend akan return JWT untuk akses API
  Future<String> verifyFirebaseToken(String firebaseToken);
}
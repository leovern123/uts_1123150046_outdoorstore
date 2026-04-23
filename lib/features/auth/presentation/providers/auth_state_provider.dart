import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/services/secure_storage.dart';

// auth status enum
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailNotVerified,
  error,
}

class AuthStateProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isVerifying = false;
  // state
  AuthStatus _status = AuthStatus.initial;
  User? _firebaseUser;
  String? _backendToken;
  String? _errorMessage;

  // getter
  AuthStatus get status => _status;
  User? get firebaseUser => _firebaseUser;
  String? get backendToken => _backendToken;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  // register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _setLoading();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firebaseUser = credential.user;

      await _firebaseUser?.updateDisplayName(name);
      await _firebaseUser?.sendEmailVerification();

      _status = AuthStatus.emailNotVerified;
      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan');
      return false;
    }
  }


  // login email

  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firebaseUser = credential.user;

      if (!(_firebaseUser?.emailVerified ?? false)) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return false;
      }

      return await _verifyTokenToBackend();
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    } catch (e) {
      _setError('Login gagal');
      return false;
    }
  }


  // login google
  Future<bool> loginWithGoogle() async {
    try {
      _setLoading();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setError('Login dibatalkan');
        return false;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      _firebaseUser = userCred.user;

      return await _verifyTokenToBackend();
    } catch (e) {
      _setError('Login Google gagal');
      return false;
    }
  }


  //verifikasi token ke backend (go)
  Future<bool> _verifyTokenToBackend() async {
    if (_isVerifying) return false;

    // cek token di storage dulu
final savedToken = await SecureStorageService.getToken();

if (savedToken != null && savedToken.isNotEmpty) {
  _backendToken = savedToken;
  _status = AuthStatus.authenticated;
  notifyListeners();
  return true;
}
  

    final user = _auth.currentUser;
    if (user == null) {
      print("SKIP: Firebase user null");
      return false;
    }

    _isVerifying = true;

    try {

     await Future.delayed(const Duration(milliseconds: 300));

final firebaseToken = await user.getIdToken(true);

if (firebaseToken == null || firebaseToken.isEmpty) {
  _setError("Firebase token belum tersedia");
  return false;
}

print("TOKEN FIREBASE: $firebaseToken");

final response = await DioClient.instance.post(
  ApiConstants.verifyToken,
  data: {
    "firebase_token": firebaseToken,
  },
);

print("RESPONSE BACKEND: ${response.data}");

final responseData = response.data as Map<String, dynamic>;

print("FULL RESPONSE: $responseData");

String? accessToken;

// coba beberapa kemungkinan
if (responseData['data'] != null) {
  final data = responseData['data'];

  if (data is Map<String, dynamic>) {
    accessToken = data['token'] ??
                  data['access_token'] ??
                  data['accessToken'];
  }
}

// fallback kalau token di root
accessToken ??= responseData['token'];

if (accessToken == null || accessToken.isEmpty) {
  _setError("Token tidak ditemukan di response backend");
  return false;
}

_backendToken = accessToken;

await SecureStorageService.saveToken(accessToken);

print("TOKEN DISIMPAN: $accessToken");

      _status = AuthStatus.authenticated;
      notifyListeners();

      return true;
    } catch (e) {
      print("ERROR VERIFY: $e");
      _setError('Gagal koneksi ke server');
      return false;
    } finally {
      _isVerifying = false;
    }
  }

//  mengirim ulang email
  Future<void> resendVerificationEmail() async {
    await _firebaseUser?.sendEmailVerification();
  }

  Future<bool> checkEmailVerified() async {
    await _firebaseUser?.reload();
    _firebaseUser = _auth.currentUser;

    return _firebaseUser?.emailVerified ?? false;
  }

  Future<bool> loginAfterEmailVerification() async {
    try {
      _setLoading();

      final user = _auth.currentUser;

      if (user == null) {
        _setError("User tidak ditemukan");
        return false;
      }

      await user.reload();
      _firebaseUser = _auth.currentUser;

      if (!(_firebaseUser?.emailVerified ?? false)) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return false;
      }

      return await _verifyTokenToBackend();
    } catch (e) {
      _setError('Verifikasi gagal');
      return false;
    }
  }

  // logout
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await SecureStorageService.clearAll();

    _firebaseUser = null;
    _backendToken = null;
    _status = AuthStatus.unauthenticated;

    notifyListeners();
  }

 //  helpers
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  String _mapFirebaseError(String code) => switch (code) {
        'email-already-in-use' => 'Email sudah terdaftar',
        'user-not-found' => 'Akun tidak ditemukan',
        'wrong-password' => 'Password salah',
        'invalid-email' => 'Email tidak valid',
        'weak-password' => 'Password terlalu lemah',
        'network-request-failed' => 'Tidak ada internet',
        _ => 'Terjadi kesalahan',
      };
}
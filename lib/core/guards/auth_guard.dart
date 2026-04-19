import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthStateProvider>().status;

    switch (status) {
      case AuthStatus.authenticated:
        return child;

      case AuthStatus.emailNotVerified:
        return const VerifyEmailPage();

      default:
        return const LoginPage();
    }
  }
}
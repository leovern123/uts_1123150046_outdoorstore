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
    final auth = context.watch<AuthStateProvider>();

    return switch (auth.status) {
      AuthStatus.authenticated    => child,
      AuthStatus.emailNotVerified => const VerifyEmailPage(),
      _                           => const LoginPage(),
    };
  }
}
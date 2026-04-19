import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/routes/app_router.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_button.dart';
import '../providers/auth_state_provider.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? _timer;
  bool _resendCooldown = false;
  int _countdown = 60;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
    // Polling: cek setiap 5 detik apakah email sudah diverifikasi
  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final auth = context.read<AuthStateProvider>();
      final success = await auth.checkEmailVerified();

      if (success && mounted) {
        _timer?.cancel();
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
      }
    });
  }

  Future<void> _resendEmail() async {
    if (_resendCooldown) return;

    await context.read<AuthStateProvider>().resendVerificationEmail();

    setState(() {
      _resendCooldown = true;
      _countdown = 60;
    });

    Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _countdown--);

      if (_countdown <= 0) {
        t.cancel();
        setState(() => _resendCooldown = false);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email verifikasi dikirim ulang')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthStateProvider>().firebaseUser;
    

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Widget reusable: AuthHeader
              const AuthHeader(
                icon: Icons.mark_email_unread_outlined,
                title: 'Verifikasi Email Kamu',
                subtitle: 'Cek email untuk aktivasi akun',
              ),

              const SizedBox(height: 24),
              // Tampilkan email user
              Text(user?.email ?? '-'),

              const SizedBox(height: 32),

              CustomButton(
                label: _resendCooldown
                    ? 'Tunggu ($_countdown)'
                    : 'Kirim Ulang Email',
                onPressed: _resendCooldown ? null : _resendEmail,
              ),

              const SizedBox(height: 16),

              CustomButton(
                label: 'Logout',
                onPressed: () {
                  context.read<AuthStateProvider>().logout();
                  Navigator.pushReplacementNamed(context, AppRouter.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
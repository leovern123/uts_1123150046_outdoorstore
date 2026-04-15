import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 48, color: AppColors.primary),
        ),
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
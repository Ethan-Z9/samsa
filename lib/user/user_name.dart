import 'package:flutter/material.dart';
import 'package:frc_scout_app/data/user_session.dart';

class UsernameDisplay extends StatelessWidget {
  const UsernameDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final session = UserSession();

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        session.fullName.isNotEmpty ? session.fullName : 'Guest',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

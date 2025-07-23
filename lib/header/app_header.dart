import 'package:flutter/material.dart';
import 'package:frc_scout_app/clock/system_clock.dart';
import 'package:frc_scout_app/user/user_menu.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // Match your theme color here if needed
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // Divider color
            width: 0.5,         // Thin line
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Left Side - Drawer Icon
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),

            // 2. Middle - Clock with Title
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SystemClock(),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),

            // 3. Right Side - User Menu
            const UserMenu(),
          ],
        ),
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
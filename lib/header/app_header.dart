import 'package:flutter/material.dart';
import 'package:frc_scout_app/clock/system_clock.dart';
import 'package:frc_scout_app/user/user_menu.dart';
import 'package:frc_scout_app/user/user_name.dart';

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
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
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
        title: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Left - Drawer Icon
              Positioned(
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),

              // Center - Clock + Title
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SystemClock(),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),

              // Right - Username + UserMenu
              Positioned(
                right: 0,
                child: Row(
                  children: const [
                    UsernameDisplay(),
                    UserMenu(),
                  ],
                ),
              ),
            ],
          ),
        ),
        centerTitle: true, // can keep or remove since we control positioning now
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
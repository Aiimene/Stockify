import 'package:flutter/material.dart';
import '../../presentation/themes/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final bool showNotifications;
  final bool showProfile;
  final List<Widget>? additionalActions;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.showNotifications = true,
    this.showProfile = true,
    this.additionalActions,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => subtitle != null 
      ? const Size.fromHeight(90) 
      : const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: subtitle != null ? 16 : 12,
          ),
          child: Row(
            children: [
              // Back button or logo space
              if (showBackButton)
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              
              if (showBackButton) const SizedBox(width: 12),
              
              // Title section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Additional actions
              if (additionalActions != null) ...additionalActions!,
              
              // Notifications icon
              if (showNotifications) ...[
                const SizedBox(width: 8),
                _AppBarIconButton(
                  icon: Icons.notifications_outlined,
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                  badgeCount: 3, // Can be made dynamic
                ),
              ],
              
              // Profile icon
              if (showProfile) ...[
                const SizedBox(width: 8),
                _ProfileButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// AppBar Icon Button with optional badge
class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final int? badgeCount;

  const _AppBarIconButton({
    required this.icon,
    required this.onPressed,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon, size: 24),
          color: AppColors.primary,
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        if (badgeCount != null && badgeCount! > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                badgeCount! > 9 ? '9+' : badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

// Profile Button
class _ProfileButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ProfileButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryLight.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: const Icon(
          Icons.person_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}


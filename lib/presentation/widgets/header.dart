import 'package:flutter/material.dart';
import 'package:flutter_app/domain/models/user/user_model.dart';
import 'package:flutter_app/core/theme/app_theme.dart';

class CustomHeader extends StatelessWidget {
  final User user;
  final VoidCallback? onNotificationTap;

  const CustomHeader({super.key, required this.user, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary.withValues(alpha: .15),
          backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
              ? NetworkImage(user.avatarUrl!) as ImageProvider
              : const AssetImage('assets/images/avatar.png'),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ravi de vous revoir,',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
            ),
            Text(
              user.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const Spacer(),

        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
              width: 0.5,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: onNotificationTap ?? () {},
          ),
        ),
      ],
    );
  }
}

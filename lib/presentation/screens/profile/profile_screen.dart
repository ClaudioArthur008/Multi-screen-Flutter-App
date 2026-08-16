import 'package:flutter/material.dart';
import 'package:flutter_app/domain/models/user/user_model.dart';
import 'package:flutter_app/data/repository/mock_user_repository.dart';
import 'package:flutter_app/data/repository/user_repository.dart';
import 'package:flutter_app/core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.userRepository = const MockUserRepository(),
  });

  final UserRepository userRepository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await widget.userRepository.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Déconnexion (démo)')));
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature — bientôt disponible')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading || _user == null
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 700;
                      final profileCard = _buildProfileCard(context, _user!);
                      final settingsList = _buildSettingsList(context);

                      if (isWide) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 320, child: profileCard),
                              const SizedBox(width: 24),
                              Expanded(child: settingsList),
                            ],
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            profileCard,
                            const SizedBox(height: 24),
                            settingsList,
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, User user) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final initials = _initialsFor(user.name);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primary,
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null
                ? Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showComingSoon(context, 'Modifier le profil'),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Modifier le profil'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final items = <_ProfileMenuItem>[
      _ProfileMenuItem(
        icon: Icons.favorite_border_rounded,
        label: 'Mes favoris',
        onTap: () => _showComingSoon(context, 'Favoris'),
      ),
      _ProfileMenuItem(
        icon: Icons.home_work_outlined,
        label: 'Mes logements publiés',
        onTap: () => _showComingSoon(context, 'Mes logements'),
      ),
      _ProfileMenuItem(
        icon: Icons.notifications_none_rounded,
        label: 'Notifications',
        onTap: () => _showComingSoon(context, 'Notifications'),
      ),
      _ProfileMenuItem(
        icon: Icons.settings_outlined,
        label: 'Paramètres',
        onTap: () => _showComingSoon(context, 'Paramètres'),
      ),
      _ProfileMenuItem(
        icon: Icons.help_outline_rounded,
        label: 'Aide & support',
        onTap: () => _showComingSoon(context, 'Aide & support'),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          for (final item in items) ...[
            ListTile(
              leading: Icon(item.icon, color: AppColors.primary),
              title: Text(item.label),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: item.onTap,
            ),
            if (item != items.last)
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: theme.dividerColor,
              ),
          ],
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text(
              'Se déconnecter',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  String _initialsFor(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}

class _ProfileMenuItem {
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

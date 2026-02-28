import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_state_provider.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryDarkBlue,
                      ),
                )
                    .animate()
                    .fadeIn()
                    .slideX(begin: -0.2, end: 0),
                const SizedBox(height: 32),
                _buildProfileSection(context),
                const SizedBox(height: 32),
                _buildSettingsSection(context),
                const SizedBox(height: 48),
                _buildLogoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              size: 40,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'User Name',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'user@example.com',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 100.ms)
        .slideY(begin: 0.1, end: 0, delay: 100.ms);
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
            )
                .animate()
                .fadeIn(delay: 200.ms),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.power_settings_new_rounded,
              title: 'Triple Click Activation',
              subtitle: 'Activate SOS with 3 quick power button presses',
              value: appState.isTripleClickEnabled,
              onChanged: (_) => appState.toggleTripleClick(),
              delay: 200.ms,
            ),
            _buildSettingTile(
              icon: Icons.mic_rounded,
              title: 'Auto Audio Recording',
              subtitle: 'Record audio when SOS is activated',
              value: appState.isAutoAudioEnabled,
              onChanged: (_) => appState.toggleAutoAudio(),
              delay: 250.ms,
            ),
            _buildSettingTile(
              icon: Icons.location_on_rounded,
              title: 'Share Location Automatically',
              subtitle: 'Share live location with contacts during emergency',
              value: appState.isAutoLocationEnabled,
              onChanged: (_) => appState.toggleAutoLocation(),
              delay: 300.ms,
            ),
            const SizedBox(height: 24),
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
            )
                .animate()
                .fadeIn(delay: 350.ms),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.dark_mode_rounded,
              title: 'Dark Mode',
              subtitle: 'Use dark theme',
              value: appState.isDarkMode,
              onChanged: (_) => appState.toggleDarkMode(),
              delay: 350.ms,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Duration delay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryPurple, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppTheme.primaryPurple,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay)
        .slideY(begin: 0.05, end: 0, delay: delay);
  }

  Widget _buildLogoutButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Provider.of<AppStateProvider>(context, listen: false).setLoggedIn(false);
        Provider.of<AppStateProvider>(context, listen: false).setOnboardingComplete(true);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
          (route) => false,
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.accentRed,
        side: const BorderSide(color: AppTheme.accentRed),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text('Logout'),
    )
        .animate()
        .fadeIn(delay: 500.ms)
        .slideY(begin: 0.1, end: 0, delay: 500.ms);
  }
}

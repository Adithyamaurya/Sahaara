import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_state_provider.dart';
import '../widgets/threat_card.dart';
import '../widgets/sos_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                const SosButton(),
                const SizedBox(height: 40),
                const ThreatCard(),
                const SizedBox(height: 32),
                _buildTripleClickCard(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sahaara',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.w700,
                  ),
            )
                .animate()
                .fadeIn()
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 4),
            Text(
              'You\'re protected',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black54,
                  ),
            )
                .animate()
                .fadeIn(delay: 100.ms)
                .slideX(begin: -0.2, end: 0, delay: 100.ms),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.person_rounded,
            color: AppTheme.primaryPurple,
            size: 28,
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms)
            .slideX(begin: 0.2, end: 0, delay: 200.ms),
      ],
    );
  }

  Widget _buildTripleClickCard(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, _) {
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Triple Power Button Emergency',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Activate SOS by pressing power button 3 times quickly',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: appState.isTripleClickEnabled,
                onChanged: (_) {
                  appState.toggleTripleClick();
                  HapticFeedback.mediumImpact();
                },
                activeTrackColor: AppTheme.primaryPurple,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 400.ms)
            .slideY(begin: 0.1, end: 0, delay: 400.ms);
      },
    );
  }
}

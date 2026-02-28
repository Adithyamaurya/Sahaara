import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_state_provider.dart';

class ThreatCard extends StatelessWidget {
  const ThreatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, _) {
        final level = appState.threatLevel;
        final levelText = level < 0.4 ? 'Low' : level < 0.7 ? 'Medium' : 'High';
        final levelColor = level < 0.4 ? Colors.green : level < 0.7 ? Colors.orange : AppTheme.accentRed;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appState.isPoliceAlertActive)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.accentRed.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.accentRed.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.policy_rounded, color: AppTheme.accentRed, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Police Alert Activated',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentRed,
                            ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn()
                  .slideX(begin: -0.2, end: 0),
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Threat Assessment Level',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: levelColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          levelText,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: levelColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: level > 0 ? level : 0.35,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(levelColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Text('Low', style: TextStyle(color: Colors.grey.shade600, fontSize: 12))),
                      Expanded(child: Text('Medium', style: TextStyle(color: Colors.grey.shade600, fontSize: 12), textAlign: TextAlign.center)),
                      Expanded(child: Text('High', style: TextStyle(color: Colors.grey.shade600, fontSize: 12), textAlign: TextAlign.end)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Simulate "Police" word detection',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                      ),
                      const Spacer(),
                      Switch.adaptive(
                        value: appState.isPoliceAlertActive,
                        onChanged: (v) {
                          appState.setPoliceAlert(v);
                          if (v) appState.setThreatLevel(0.85);
                        },
                        activeTrackColor: AppTheme.primaryPurple,
                      ),
                    ],
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms)
                .slideY(begin: 0.1, end: 0, delay: 300.ms),
          ],
        );
      },
    );
  }
}

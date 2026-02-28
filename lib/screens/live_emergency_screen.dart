import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_state_provider.dart';
import '../services/mock_emergency_service.dart';
import 'main_shell.dart';

class LiveEmergencyScreen extends StatefulWidget {
  const LiveEmergencyScreen({super.key});

  @override
  State<LiveEmergencyScreen> createState() => _LiveEmergencyScreenState();
}

class _LiveEmergencyScreenState extends State<LiveEmergencyScreen>
    with TickerProviderStateMixin {
  final MockEmergencyService _emergencyService = MockEmergencyService();
  late AnimationController _pulseController;
  Map<String, dynamic>? _location;

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  Future<void> _loadLocation() async {
    final loc = await _emergencyService.getMockLocation();
    if (mounted) setState(() => _location = loc);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _deactivateSos() {
    HapticFeedback.mediumImpact();
    Provider.of<AppStateProvider>(context, listen: false).setSosActive(false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildPulseBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildStatusBanner(),
                        const SizedBox(height: 32),
                        _buildMapPlaceholder(),
                        const SizedBox(height: 24),
                        _buildCoordinatesCard(),
                        const SizedBox(height: 24),
                        _buildWaveformPlaceholder(),
                        const SizedBox(height: 24),
                        _buildStatusList(),
                        const SizedBox(height: 48),
                        _buildDeactivateButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseBackground() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.5 + (_pulseController.value * 0.2),
              colors: [
                AppTheme.accentRed.withValues(alpha: 0.15),
                AppTheme.accentRed.withValues(alpha: 0.05),
                Colors.white,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.emergency_rounded, color: AppTheme.accentRed, size: 32),
          const SizedBox(width: 12),
          Text(
            'Emergency Mode',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentRed,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentRed.withValues(alpha: 0.2),
            AppTheme.accentRed.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.accentRed.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppTheme.accentRed, size: 48)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 800.ms),
          const SizedBox(height: 16),
          Text(
            'Emergency Mode Activated',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentRed,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn()
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.map_rounded, size: 80, color: Colors.grey.shade400),
          Positioned(
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.pin_drop_rounded, color: AppTheme.accentRed, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Live Location',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms)
        .slideY(begin: 0.1, end: 0, delay: 200.ms);
  }

  Widget _buildCoordinatesCard() {
    final lat = _location?['lat'] ?? 12.9716;
    final lng = _location?['lng'] ?? 77.5946;
    final address = _location?['address'] ?? 'Bangalore, Karnataka';

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coordinates',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            '$lat, $lng',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'monospace',
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms)
        .slideY(begin: 0.1, end: 0, delay: 300.ms);
  }

  Widget _buildWaveformPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mic_rounded, color: AppTheme.primaryPurple),
              const SizedBox(width: 8),
              Text(
                'Audio Recording',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              15,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 6,
                height: 20 + ((i % 5) * 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.3 + (i * 0.04)),
                  borderRadius: BorderRadius.circular(3),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleY(begin: 0.6, end: 1, duration: (300 + i * 50).ms, delay: (i * 30).ms)
                  .then()
                  .scaleY(begin: 1, end: 0.6, duration: (300 + i * 50).ms),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 400.ms)
        .slideY(begin: 0.1, end: 0, delay: 400.ms);
  }

  Widget _buildStatusList() {
    final statuses = [
      _StatusItem(icon: Icons.share_rounded, text: 'Sharing with NGO', color: Colors.green),
      _StatusItem(icon: Icons.analytics_rounded, text: 'Monitoring threat level', color: Colors.orange),
      _StatusItem(icon: Icons.phone_rounded, text: 'Contacts notified', color: AppTheme.primaryPurple),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        ...statuses.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: e.value.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(e.value.icon, color: e.value.color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      e.value.text,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            )),
      ],
    )
        .animate()
        .fadeIn(delay: 500.ms)
        .slideY(begin: 0.1, end: 0, delay: 500.ms);
  }

  Widget _buildDeactivateButton() {
    return OutlinedButton(
      onPressed: _deactivateSos,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.accentRed,
        side: const BorderSide(color: AppTheme.accentRed),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text('Deactivate Emergency Mode'),
    )
        .animate()
        .fadeIn(delay: 600.ms)
        .slideY(begin: 0.1, end: 0, delay: 600.ms);
  }
}

class _StatusItem {
  final IconData icon;
  final String text;
  final Color color;

  _StatusItem({required this.icon, required this.text, required this.color});
}

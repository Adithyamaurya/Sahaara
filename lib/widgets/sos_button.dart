import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_state_provider.dart';

class SosButton extends StatefulWidget {
  const SosButton({super.key});

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  Timer? _holdTimer;
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _rippleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _holdTimer = Timer(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      _activateSos();
    });
    _rippleController.repeat();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _holdTimer?.cancel();
    _rippleController.stop();
    _rippleController.reset();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _holdTimer?.cancel();
    _rippleController.stop();
    _rippleController.reset();
  }

  void _activateSos() {
    _holdTimer?.cancel();
    HapticFeedback.heavyImpact();
    _showSosDialog();
    Provider.of<AppStateProvider>(context, listen: false).setSosActive(true);
  }

  void _showSosDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.accentRed, size: 32),
            const SizedBox(width: 12),
            const Text('SOS Activated'),
          ],
        ),
        content: const Text(
          'Emergency mode has been activated. Your location is being shared with your emergency contacts and NGOs.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: const Text('Continue to Emergency'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _rippleAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(200, 200),
                      painter: _RipplePainter(
                        progress: _rippleAnimation.value,
                        color: AppTheme.accentRed.withValues(alpha: 0.3),
                      ),
                    );
                  },
                ),
                AnimatedScale(
                  scale: _isPressed ? 0.92 : 1,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.accentRed,
                          AppTheme.accentRedDark,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentRed.withValues(alpha: 0.5),
                          blurRadius: _isPressed ? 20 : 30,
                          spreadRadius: _isPressed ? 2 : 4,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        customBorder: const CircleBorder(),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                size: 48,
                                color: Colors.white.withValues(alpha: 0.95),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'HOLD FOR SOS',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.95),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 600.ms)
              .fadeIn(duration: 600.ms),
          const SizedBox(height: 16),
          Text(
            'Hold for 2 seconds to activate',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
          )
              .animate()
              .fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  _RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final radius = (size.width / 2) * progress * 1.2;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) => progress != oldDelegate.progress;
}

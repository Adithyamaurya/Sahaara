import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_state_provider.dart';
import '../models/onboarding_model.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> _slides = [
    OnboardingModel(
      title: 'Your Safety. One Tap Away.',
      description: 'Activate emergency SOS with a single long press. Help is just moments away when you need it most.',
      icon: Icons.shield_rounded,
    ),
    OnboardingModel(
      title: 'Instant Location Sharing',
      description: 'Your live location is automatically shared with emergency contacts and authorities when you activate SOS.',
      icon: Icons.location_on_rounded,
    ),
    OnboardingModel(
      title: 'Smart Audio Detection',
      description: 'Our AI monitors ambient audio to detect distress signals and alert help when you cannot speak.',
      icon: Icons.mic_rounded,
    ),
  ];

  void _onGetStarted() {
    Provider.of<AppStateProvider>(context, listen: false).setOnboardingComplete(true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFF5F0FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _onGetStarted,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _slides.length,
                  itemBuilder: (context, index) => _buildSlide(_slides[index], index),
                ),
              ),
              _buildPageIndicator(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _slides.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _onGetStarted();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingModel slide, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIllustration(slide, index),
          const SizedBox(height: 48),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryDarkBlue,
                  fontWeight: FontWeight.w700,
                ),
          )
              .animate()
              .fadeIn(delay: (200 * (index + 1)).ms)
              .slideY(begin: 0.2, end: 0, delay: (200 * (index + 1)).ms),
          const SizedBox(height: 16),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                  height: 1.5,
                ),
          )
              .animate()
              .fadeIn(delay: (300 * (index + 1)).ms)
              .slideY(begin: 0.2, end: 0, delay: (300 * (index + 1)).ms),
        ],
      ),
    );
  }

  Widget _buildIllustration(OnboardingModel slide, int index) {
    Widget content;
    switch (index) {
      case 0:
        content = Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryPurple.withValues(alpha: 0.2),
                AppTheme.primaryPurple.withValues(alpha: 0.05),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(slide.icon, size: 80, color: AppTheme.primaryPurple),
        );
        break;
      case 1:
        content = Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.map_rounded, size: 100, color: AppTheme.primaryPurple.withValues(alpha: 0.5)),
              Positioned(
                bottom: 40,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentRed,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.my_location, color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
        );
        break;
      case 2:
        content = Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryPurple.withValues(alpha: 0.15),
                AppTheme.primaryPurple.withValues(alpha: 0.05),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 30 + (i % 3) * 20.0,
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withValues(alpha: (0.4 + i * 0.12).clamp(0.0, 1.0)),
                  borderRadius: BorderRadius.circular(4),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleY(begin: 0.5, end: 1, duration: (400 + i * 100).ms, delay: (i * 50).ms)
                  .then()
                  .scaleY(begin: 1, end: 0.5, duration: (400 + i * 100).ms),
            ),
          ),
        );
        break;
      default:
        content = Icon(slide.icon, size: 120, color: AppTheme.primaryPurple);
    }
    return content
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 600.ms);
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppTheme.primaryPurple : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    ).animate().fadeIn();
  }
}

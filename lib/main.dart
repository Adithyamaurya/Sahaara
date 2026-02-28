import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_state_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SahraApp());
}

class SahraApp extends StatelessWidget {
  const SahraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<AppStateProvider>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Sahaara',
            debugShowCheckedModeBanner: false,
            theme: appState.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

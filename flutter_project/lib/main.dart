import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_colors.dart';
import 'core/services/appwrite_service.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/marketplace/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: ChitralShopApp(),
    ),
  );
}

class ChitralShopApp extends StatelessWidget {
  const ChitralShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chitral Shop',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDeep,
        primaryColor: AppColors.neonCyan,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.neonCyan,
          secondary: AppColors.neonViolet,
          surface: AppColors.surfaceCard,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              return states.contains(MaterialState.selected)
                  ? Colors.white
                  : AppColors.textSecondary;
            }),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return states.contains(MaterialState.selected)
                  ? const Color(0xFF334B99)
                  : const Color(0x220F1A34);
            }),
            side: MaterialStateProperty.all(
              BorderSide(color: Colors.white.withOpacity(0.18)),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.neonCyan,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  final _appwriteService = AppwriteService();
  late Future<bool> _hasSession;

  @override
  void initState() {
    super.initState();
    _hasSession = _checkSession();
  }

  Future<bool> _checkSession() async {
    final user = await _appwriteService.getCurrentUser();
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSession,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.neonCyan),
            ),
          );
        }

        if (snapshot.data == true) {
          return const MarketplaceHomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}

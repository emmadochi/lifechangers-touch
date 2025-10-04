import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

class LifechangersTouchApp extends StatelessWidget {
  const LifechangersTouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add providers here as they are implemented
        // ChangeNotifierProvider(create: (_) => AuthProvider()),
        // ChangeNotifierProvider(create: (_) => ContentProvider()),
        // ChangeNotifierProvider(create: (_) => WalletProvider()),
        // ChangeNotifierProvider(create: (_) => DownloadProvider()),
        // ChangeNotifierProvider(create: (_) => StreamProvider()),
      ],
      child: MaterialApp.router(
        title: 'Lifechangers Touch',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

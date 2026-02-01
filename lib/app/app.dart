import 'package:amin_pass/auth/screen/login_screen.dart';
import 'package:amin_pass/onBoarding/splash_screen.dart';
import 'package:amin_pass/theme/theme_data.dart';
import 'package:amin_pass/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AminPass extends StatelessWidget {
  const AminPass({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
       return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppThemeData.lightTheme,
          darkTheme: AppThemeData.darkTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: SplashScreen(),
        );
      },
    );
  }
}

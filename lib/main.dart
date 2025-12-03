import 'package:flutter/material.dart';
import 'package:movieverse/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:movieverse/services/api_service.dart';
import 'package:device_preview/device_preview.dart'; // استيراد مكتبة Device Preview

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => 
        ChangeNotifierProvider(
          create: (_) => ApiService(),
          child: const MovieAPP(),
        ),
    ),
  );
}

class MovieAPP extends StatelessWidget {
  const MovieAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,      
      home: const SplashScreen(),
    );
  }
}

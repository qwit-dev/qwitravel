import 'package:flutter/material.dart';
import 'package:qwitravel/ui/auth/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 200,
              ),
              const Text('Hello Hungary, (project_qwitravel_dev) is coming!'),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/login',
                    );
                  },
                  child: Text('Login')),
            ],
          ),
        ),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do/screens/splash/splashScreen.dart';
import 'package:to_do/TaskProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}

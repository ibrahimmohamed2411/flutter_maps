import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/app_router.dart';
import 'package:flutter_maps/constants/strings.dart';
import 'package:flutter_maps/presentation_layer/screens/login_screen.dart';

late String initialRoute;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      initialRoute = loginScreen;
    } else {
      initialRoute = mapScreen;
    }
  });
  runApp(MyApp(AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  MyApp(this.appRouter);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // onGenerateRoute: appRouter.generateRoute,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute,
    );
  }
}

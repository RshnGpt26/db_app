import 'package:db_example/screens/home_screen.dart';
import 'package:db_example/screens/note_add_update_screen.dart';
import 'package:flutter/material.dart';

import '../screens/note_details_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String noteAddUpdate = '/note_add_update';
  static const String noteDetailsScreen = '/note_details_screen';

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case noteAddUpdate:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (_) => NoteAddUpdateScreen(
                isAdding: args["isAdding"] ?? false,
                onSave: args["onSaveClick"] ?? () {},
                oldTitle: args["oldTitle"] ?? "",
                oldDesc: args["oldDesc"] ?? "",
              ),
        );
      case noteDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => NoteDetailsScreen(note: args));
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}

import 'package:db_example/providers/notes_provider.dart';
import 'package:db_example/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NotesProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        fontFamily: "Roboto",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black12,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          toolbarHeight: 80,
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 20),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color.fromARGB(255, 53, 51, 51),
          elevation: 5,
          foregroundColor: Colors.white,
          iconSize: 30,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 75, 73, 73),
          ),
          displayMedium: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          labelMedium: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          labelSmall: TextStyle(
            fontSize: 14,
            color: const Color.fromARGB(255, 213, 190, 190),
            fontWeight: FontWeight.w400,
          ),
          bodyLarge: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 75, 73, 73),
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoutes,
    );
  }
}

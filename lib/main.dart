import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/Initial_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData().copyWith(
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.onPrimary,
          ),
          cardTheme: const CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
          ),
          textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
            titleSmall: GoogleFonts.ubuntuCondensed(
              fontWeight: FontWeight.bold,
            ),
            titleMedium: GoogleFonts.ubuntuCondensed(
              fontWeight: FontWeight.bold,
            ),
            titleLarge: GoogleFonts.ubuntuCondensed(
              fontWeight: FontWeight.bold,
            ),
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        home: 
          const InitialScreen(),
        
      ),
    );
  }
}

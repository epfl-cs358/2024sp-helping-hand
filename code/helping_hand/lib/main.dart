import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:helping_hand/view/navigation/routes.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      fontFamily: GoogleFonts.roboto().fontFamily,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
      ),
    );

    return ProviderScope(
      child: MaterialApp(
        title: "Helping Hand",
        onGenerateRoute: generateRoute,
        initialRoute: Routes.overview.name,
        theme: theme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

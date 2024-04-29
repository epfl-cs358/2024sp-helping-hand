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
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);
    final theme = ThemeData(
      useMaterial3: true,
      // Define the default brightness and colors.
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: brightness,
      ),
      fontFamily: GoogleFonts.roboto().fontFamily,
    );

    return ProviderScope(
      child: MaterialApp(
        title: "Helping Hand",
        onGenerateRoute: generateRoute,
        initialRoute: Routes.overview.name,
        theme: theme,
      ),
    );
  }
}

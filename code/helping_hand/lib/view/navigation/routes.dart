import "package:flutter/material.dart";
import "package:helping_hand/view/pages/overview.dart";

enum Routes {
  overview("overview");

  final String name;

  const Routes(this.name);

  static Routes parse(String name) {
    return Routes.values.firstWhere((r) => r.name == name);
  }

  Widget page(Object? args) {
    switch (this) {
      case overview:
        return const OverviewPage();
    }
  }
}

Route generateRoute(RouteSettings settings) {
  final route = Routes.parse(settings.name ?? Routes.overview.name);
  return MaterialPageRoute(builder: (_) => route.page(settings.arguments));
}

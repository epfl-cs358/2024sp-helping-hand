import "package:flutter/material.dart";
import "package:helping_hand/model/network.dart";
import "package:helping_hand/view/pages/overview/overview_page.dart";
import "package:helping_hand/view/pages/remote/remote_page.dart";

enum Routes {
  overview("overview"),
  remote("remote");

  final String name;

  const Routes(this.name);

  static Routes parse(String name) {
    return Routes.values.firstWhere((r) => r.name == name);
  }

  Widget page(Object? args) {
    switch (this) {
      case overview:
        return const OverviewPage();
      case remote:
        return RemotePage(mac: args as MacAddress);
    }
  }
}

Route generateRoute(RouteSettings settings) {
  final route = Routes.parse(settings.name ?? Routes.overview.name);
  return MaterialPageRoute(builder: (_) => route.page(settings.arguments));
}

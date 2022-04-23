import 'package:flutter/material.dart';
import 'package:fruit/app/core/route_map.dart';
import 'package:fruit/app/core/service_locator.dart';
import 'package:fruit/ui/page/fruit_page.dart';

/// author: febri.arianto@bukalapak.com
/// date: 2022-04-23

class AppRouteMap extends RouteMap {
  final ServiceLocator _locator;

  AppRouteMap(this._locator);

  @override
  Route get(RouteSettings settings) {
    if (settings.name == '/') {
      return FruitPageRoute(bloc: _locator());
    }
    return MaterialPageRoute(
      builder: (context) => Text('${settings.name} Route Not Found'),
    );
  }
}

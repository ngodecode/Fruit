import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fruit/app/core/network_client.dart';
import 'package:fruit/app/core/route_map.dart';
import 'package:fruit/app/core/service_locator.dart';
import 'package:fruit/app/locale/app_localizations_delegate.dart';
import 'package:fruit/app/network/AppNetworkClient.dart';
import 'package:fruit/app/route/AppRouteMap.dart';
import 'package:fruit/app/service_locator/AppServiceLocator.dart';
import 'package:fruit/bloc/fruit_bloc.dart';
import 'package:fruit/datasource/FruitDataSource.dart';
import 'package:fruit/network/api/fruit_api.dart';
import 'package:fruit/repository/FruitRepository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final ServiceLocator locator = AppServiceLocator();
  // Core
  locator.registerFactory<NetworkClient>(AppNetworkClient());
  locator.registerFactory<RouteMap>(AppRouteMap(locator));

  // Fruit
  locator.registerFactory(FruitApi(locator()));
  locator.registerFactory(FruitDataSource(locator()));
  locator.registerFactory(FruitRepository(locator()));
  locator.registerFactory(FruitBloc(locator()));

  runApp(MyApp(locator));
}

class MyApp extends StatelessWidget {
  final ServiceLocator _locator;

  const MyApp(this._locator, {Key? key}) : super(key: key);

  Future<bool> initiating() async {
    // put other here
    await Firebase.initializeApp();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initiating(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _app();
        } else {
          return _splashScreen();
        }
      },
    );
  }

  Widget _splashScreen() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _app() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/pdf',
      onGenerateRoute: (settings) {
        return _locator<RouteMap>().get(settings);
      },
    );
  }
}

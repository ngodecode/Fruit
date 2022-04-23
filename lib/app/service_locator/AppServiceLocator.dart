import 'package:fruit/app/core/service_locator.dart';
import 'package:get_it/get_it.dart';

/// author: febri.arianto@bukalapak.com
/// date: 2022-04-23


class AppServiceLocator extends ServiceLocator{

  late GetIt getIt;

  AppServiceLocator() {
    getIt = GetIt.instance;
  }

  @override
  T call<T extends Object>() {
    return getIt.get<T>();
  }

  @override
  registerFactory<T extends Object>(T t) {
    getIt.registerFactory<T>(() => t);
  }

  @override
  registerSingleton<T extends Object>(T t) {
    getIt.registerSingleton<T>(t);
  }

}
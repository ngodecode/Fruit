/// author: febri.arianto@bukalapak.com
/// date: 2022-04-23


abstract class ServiceLocator {

  registerSingleton<T extends Object>(T t);

  registerFactory<T extends Object>(T t);

  T call<T extends Object>();

}
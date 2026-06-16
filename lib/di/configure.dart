import 'package:e_comm_user/bloc/cart/cart_bloc.dart';
import 'package:e_comm_user/bloc/category/category_bloc.dart';
import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/local_cart_database.dart';
import 'package:e_comm_user/data/cart_data_sources/cart_local_data_source.dart';
import 'package:e_comm_user/data/cart_data_sources/cart_remote_data_source.dart';
import 'package:e_comm_user/repository/cart_repository.dart';
import 'package:e_comm_user/repository/category_repository.dart';
import 'package:e_comm_user/repository/product_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'configure.config.dart';
final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

Future<void> registerAdditionalDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerSingleton<SharedPreferences>(prefs);
  }
  if (!getIt.isRegistered<CategoryRepository>()) {
    getIt.registerFactory<CategoryRepository>(() => CategoryRepositoryImpl(getIt<ApiClient>()));
  }
  if (!getIt.isRegistered<CategoryBloc>()) {
    getIt.registerFactory<CategoryBloc>(() => CategoryBloc());
  }
  if (!getIt.isRegistered<LocalCartDatabase>()) {
    getIt.registerSingleton<LocalCartDatabase>(LocalCartDatabase());
  }
  if (!getIt.isRegistered<CartLocalDataSource>()) {
    getIt.registerFactory<CartLocalDataSource>(() => CartLocalDataSourceImpl(getIt<LocalCartDatabase>()));
  }
  if (!getIt.isRegistered<CartRemoteDataSource>()) {
    getIt.registerFactory<CartRemoteDataSource>(() => CartRemoteDataSourceImpl(getIt<ApiClient>()));
  }
  if (!getIt.isRegistered<CartRepository>()) {
    getIt.registerFactory<CartRepository>(() => CartRepositoryImpl(
          getIt<CartLocalDataSource>(),
          getIt<CartRemoteDataSource>(),
          getIt<ProductRepository>(),
        ));
  }
  if (!getIt.isRegistered<CartBloc>()) {
    getIt.registerLazySingleton<CartBloc>(() => CartBloc());
  }
}

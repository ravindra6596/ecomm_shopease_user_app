// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:e_comm_user/bloc/address/address_bloc.dart' as _i554;
import 'package:e_comm_user/bloc/auth/auth_bloc.dart' as _i282;
import 'package:e_comm_user/bloc/cart/cart_bloc.dart' as _i374;
import 'package:e_comm_user/bloc/category/category_bloc.dart' as _i1036;
import 'package:e_comm_user/bloc/chatbot/chatbot_bloc.dart' as _i805;
import 'package:e_comm_user/bloc/filter/filter_bloc.dart' as _i1071;
import 'package:e_comm_user/bloc/home/home_bloc.dart' as _i342;
import 'package:e_comm_user/bloc/map/map_bloc.dart' as _i367;
import 'package:e_comm_user/bloc/navigation/navigation_bloc.dart' as _i159;
import 'package:e_comm_user/bloc/onboarding/onboarding_bloc.dart' as _i495;
import 'package:e_comm_user/bloc/order/order_bloc.dart' as _i849;
import 'package:e_comm_user/bloc/product/product_bloc.dart' as _i178;
import 'package:e_comm_user/bloc/profile/profile_bloc.dart' as _i527;
import 'package:e_comm_user/bloc/search_filed/search_field_bloc.dart' as _i971;
import 'package:e_comm_user/bloc/user/user_bloc.dart' as _i367;
import 'package:e_comm_user/bloc/wishlist/wishlist_bloc.dart' as _i976;
import 'package:e_comm_user/core/api_client.dart' as _i250;
import 'package:e_comm_user/core/local_cart_database.dart' as _i124;
import 'package:e_comm_user/data/cart_data_sources/cart_local_data_source.dart'
    as _i469;
import 'package:e_comm_user/data/cart_data_sources/cart_remote_data_source.dart'
    as _i893;
import 'package:e_comm_user/data/wishlist_data_source/wishlist_local_data_source.dart'
    as _i705;
import 'package:e_comm_user/data/wishlist_data_source/wishlist_remote_data_source.dart'
    as _i524;
import 'package:e_comm_user/repository/address_repository.dart' as _i20;
import 'package:e_comm_user/repository/auth_repository.dart' as _i253;
import 'package:e_comm_user/repository/cart_repository.dart' as _i625;
import 'package:e_comm_user/repository/chatbot_repository.dart' as _i812;
import 'package:e_comm_user/repository/home_repository.dart' as _i101;
import 'package:e_comm_user/repository/order_repository.dart' as _i462;
import 'package:e_comm_user/repository/product_repository.dart' as _i802;
import 'package:e_comm_user/repository/profile_repository.dart' as _i196;
import 'package:e_comm_user/repository/user_repository.dart' as _i913;
import 'package:e_comm_user/repository/wishlist_repository.dart' as _i483;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i253.AuthRepository>(() => _i253.AuthRepository());
    gh.factory<_i849.OrderBloc>(() => _i849.OrderBloc());
    gh.factory<_i342.HomeBloc>(() => _i342.HomeBloc());
    gh.factory<_i1036.CategoryBloc>(() => _i1036.CategoryBloc());
    gh.factory<_i282.AuthBloc>(() => _i282.AuthBloc());
    gh.factory<_i159.NavigationBloc>(() => _i159.NavigationBloc());
    gh.factory<_i367.UserBloc>(() => _i367.UserBloc());
    gh.factory<_i178.ProductBloc>(() => _i178.ProductBloc());
    gh.factory<_i367.MapBloc>(() => _i367.MapBloc());
    gh.factory<_i527.ProfileBloc>(() => _i527.ProfileBloc());
    gh.factory<_i554.AddressBloc>(() => _i554.AddressBloc());
    gh.factory<_i1071.FilterBloc>(() => _i1071.FilterBloc());
    gh.factory<_i495.OnboardingBloc>(() => _i495.OnboardingBloc());
    gh.lazySingleton<_i374.CartBloc>(() => _i374.CartBloc());
    gh.lazySingleton<_i976.WishlistBloc>(() => _i976.WishlistBloc());
    gh.factory<_i469.CartLocalDataSource>(
        () => _i469.CartLocalDataSourceImpl(gh<_i124.LocalCartDatabase>()));
    gh.factory<_i705.WishlistLocalDataSource>(
        () => _i705.WishlistLocalDataSourceImpl(gh<_i124.LocalCartDatabase>()));
    gh.factory<_i462.OrderRepository>(
        () => _i462.OrderRepositoryImpl(gh<_i250.ApiClient>()));
    gh.factory<_i196.ProfileRepository>(
        () => _i196.ProfileRepositoryImpl(gh<_i250.ApiClient>()));
    gh.factory<_i812.ChatBotRepository>(
        () => _i812.ChatBotRepositoryImpl(gh<_i250.ApiClient>()));
    gh.factory<_i20.AddressRepository>(
        () => _i20.AddressRepositoryImpl(gh<_i250.ApiClient>()));
    gh.factory<_i913.UserRepository>(
        () => _i913.UserRepositoryImpl(gh<_i250.ApiClient>()));
    gh.factory<_i524.WishlistRemoteDataSource>(
        () => _i524.WishlistRemoteDataSourceImpl(gh<_i250.ApiClient>()));
    gh.factory<_i971.SearchBloc>(() => _i971.SearchBloc(
          allItems: gh<List<String>>(),
          hints: gh<List<String>>(),
        ));
    gh.factory<_i101.HomeRepository>(
        () => _i101.AddressRepositoryImpl(gh<_i250.ApiClient>()));
    gh.factory<_i893.CartRemoteDataSource>(
        () => _i893.CartRemoteDataSourceImpl(gh<_i250.ApiClient>()));
    gh.factory<_i802.ProductRepository>(
        () => _i802.ProductRepositoryImpl(gh<_i250.ApiClient>()));
    gh.factory<_i483.WishlistRepository>(() => _i483.WishlistRepositoryImpl(
          gh<_i705.WishlistLocalDataSource>(),
          gh<_i524.WishlistRemoteDataSource>(),
          gh<_i802.ProductRepository>(),
        ));
    gh.factory<_i805.ChatbotBloc>(
        () => _i805.ChatbotBloc(gh<_i812.ChatBotRepository>()));
    gh.factory<_i625.CartRepository>(() => _i625.CartRepositoryImpl(
          gh<_i469.CartLocalDataSource>(),
          gh<_i893.CartRemoteDataSource>(),
          gh<_i802.ProductRepository>(),
        ));
    return this;
  }
}

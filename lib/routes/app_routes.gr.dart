// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_routes.dart';

/// generated route for
/// [AccountScreen]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute({List<PageRouteInfo>? children})
    : super(AccountRoute.name, initialChildren: children);

  static const String name = 'AccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AccountScreen();
    },
  );
}

/// generated route for
/// [AddressListScreen]
class AddressListRoute extends PageRouteInfo<AddressListRouteArgs> {
  AddressListRoute({
    Key? key,
    String? isFrom = '',
    int? orderId,
    List<PageRouteInfo>? children,
  }) : super(
         AddressListRoute.name,
         args: AddressListRouteArgs(key: key, isFrom: isFrom, orderId: orderId),
         initialChildren: children,
       );

  static const String name = 'AddressListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddressListRouteArgs>(
        orElse: () => const AddressListRouteArgs(),
      );
      return AddressListScreen(
        key: args.key,
        isFrom: args.isFrom,
        orderId: args.orderId,
      );
    },
  );
}

class AddressListRouteArgs {
  const AddressListRouteArgs({this.key, this.isFrom = '', this.orderId});

  final Key? key;

  final String? isFrom;

  final int? orderId;

  @override
  String toString() {
    return 'AddressListRouteArgs{key: $key, isFrom: $isFrom, orderId: $orderId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddressListRouteArgs) return false;
    return key == other.key &&
        isFrom == other.isFrom &&
        orderId == other.orderId;
  }

  @override
  int get hashCode => key.hashCode ^ isFrom.hashCode ^ orderId.hashCode;
}

/// generated route for
/// [CartScreen]
class CartRoute extends PageRouteInfo<void> {
  const CartRoute({List<PageRouteInfo>? children})
    : super(CartRoute.name, initialChildren: children);

  static const String name = 'CartRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CartScreen();
    },
  );
}

/// generated route for
/// [CategoriesScreen]
class CategoriesRoute extends PageRouteInfo<void> {
  const CategoriesRoute({List<PageRouteInfo>? children})
    : super(CategoriesRoute.name, initialChildren: children);

  static const String name = 'CategoriesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CategoriesScreen();
    },
  );
}

/// generated route for
/// [ChatbotScreen]
class ChatbotRoute extends PageRouteInfo<void> {
  const ChatbotRoute({List<PageRouteInfo>? children})
    : super(ChatbotRoute.name, initialChildren: children);

  static const String name = 'ChatbotRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChatbotScreen();
    },
  );
}

/// generated route for
/// [CheckoutScreen]
class CheckoutRoute extends PageRouteInfo<void> {
  const CheckoutRoute({List<PageRouteInfo>? children})
    : super(CheckoutRoute.name, initialChildren: children);

  static const String name = 'CheckoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CheckoutScreen();
    },
  );
}

/// generated route for
/// [CreateAddressScreen]
class CreateAddressRoute extends PageRouteInfo<CreateAddressRouteArgs> {
  CreateAddressRoute({
    Key? key,
    AddressData? addressData,
    List<PageRouteInfo>? children,
  }) : super(
         CreateAddressRoute.name,
         args: CreateAddressRouteArgs(key: key, addressData: addressData),
         initialChildren: children,
       );

  static const String name = 'CreateAddressRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateAddressRouteArgs>(
        orElse: () => const CreateAddressRouteArgs(),
      );
      return CreateAddressScreen(key: args.key, addressData: args.addressData);
    },
  );
}

class CreateAddressRouteArgs {
  const CreateAddressRouteArgs({this.key, this.addressData});

  final Key? key;

  final AddressData? addressData;

  @override
  String toString() {
    return 'CreateAddressRouteArgs{key: $key, addressData: $addressData}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreateAddressRouteArgs) return false;
    return key == other.key && addressData == other.addressData;
  }

  @override
  int get hashCode => key.hashCode ^ addressData.hashCode;
}

/// generated route for
/// [FAQScreen]
class FAQRoute extends PageRouteInfo<FAQRouteArgs> {
  FAQRoute({Key? key, List<PageRouteInfo>? children})
    : super(
        FAQRoute.name,
        args: FAQRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'FAQRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FAQRouteArgs>(
        orElse: () => const FAQRouteArgs(),
      );
      return FAQScreen(key: args.key);
    },
  );
}

class FAQRouteArgs {
  const FAQRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'FAQRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FAQRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<MainRouteArgs> {
  MainRoute({Key? key, int selectedIndex = 0, List<PageRouteInfo>? children})
    : super(
        MainRoute.name,
        args: MainRouteArgs(key: key, selectedIndex: selectedIndex),
        initialChildren: children,
      );

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MainRouteArgs>(
        orElse: () => const MainRouteArgs(),
      );
      return MainScreen(key: args.key, selectedIndex: args.selectedIndex);
    },
  );
}

class MainRouteArgs {
  const MainRouteArgs({this.key, this.selectedIndex = 0});

  final Key? key;

  final int selectedIndex;

  @override
  String toString() {
    return 'MainRouteArgs{key: $key, selectedIndex: $selectedIndex}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MainRouteArgs) return false;
    return key == other.key && selectedIndex == other.selectedIndex;
  }

  @override
  int get hashCode => key.hashCode ^ selectedIndex.hashCode;
}

/// generated route for
/// [OffersScreen]
class OffersRoute extends PageRouteInfo<OffersRouteArgs> {
  OffersRoute({Key? key, int? categoryId, List<PageRouteInfo>? children})
    : super(
        OffersRoute.name,
        args: OffersRouteArgs(key: key, categoryId: categoryId),
        initialChildren: children,
      );

  static const String name = 'OffersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OffersRouteArgs>(
        orElse: () => const OffersRouteArgs(),
      );
      return OffersScreen(key: args.key, categoryId: args.categoryId);
    },
  );
}

class OffersRouteArgs {
  const OffersRouteArgs({this.key, this.categoryId});

  final Key? key;

  final int? categoryId;

  @override
  String toString() {
    return 'OffersRouteArgs{key: $key, categoryId: $categoryId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OffersRouteArgs) return false;
    return key == other.key && categoryId == other.categoryId;
  }

  @override
  int get hashCode => key.hashCode ^ categoryId.hashCode;
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<OnboardingRouteArgs> {
  OnboardingRoute({Key? key, List<PageRouteInfo>? children})
    : super(
        OnboardingRoute.name,
        args: OnboardingRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnboardingRouteArgs>(
        orElse: () => const OnboardingRouteArgs(),
      );
      return OnboardingScreen(key: args.key);
    },
  );
}

class OnboardingRouteArgs {
  const OnboardingRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'OnboardingRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OnboardingRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [OrderDetailsScreen]
class OrderDetailsRoute extends PageRouteInfo<OrderDetailsRouteArgs> {
  OrderDetailsRoute({
    Key? key,
    int orderId = 0,
    String? isFrom,
    List<PageRouteInfo>? children,
  }) : super(
         OrderDetailsRoute.name,
         args: OrderDetailsRouteArgs(
           key: key,
           orderId: orderId,
           isFrom: isFrom,
         ),
         initialChildren: children,
       );

  static const String name = 'OrderDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailsRouteArgs>(
        orElse: () => const OrderDetailsRouteArgs(),
      );
      return OrderDetailsScreen(
        key: args.key,
        orderId: args.orderId,
        isFrom: args.isFrom,
      );
    },
  );
}

class OrderDetailsRouteArgs {
  const OrderDetailsRouteArgs({this.key, this.orderId = 0, this.isFrom});

  final Key? key;

  final int orderId;

  final String? isFrom;

  @override
  String toString() {
    return 'OrderDetailsRouteArgs{key: $key, orderId: $orderId, isFrom: $isFrom}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderDetailsRouteArgs) return false;
    return key == other.key &&
        orderId == other.orderId &&
        isFrom == other.isFrom;
  }

  @override
  int get hashCode => key.hashCode ^ orderId.hashCode ^ isFrom.hashCode;
}

/// generated route for
/// [OrderSuccessScreen]
class OrderSuccessRoute extends PageRouteInfo<OrderSuccessRouteArgs> {
  OrderSuccessRoute({
    Key? key,
    OrderCreateModel? orderCreateModel,
    List<PageRouteInfo>? children,
  }) : super(
         OrderSuccessRoute.name,
         args: OrderSuccessRouteArgs(
           key: key,
           orderCreateModel: orderCreateModel,
         ),
         initialChildren: children,
       );

  static const String name = 'OrderSuccessRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderSuccessRouteArgs>(
        orElse: () => const OrderSuccessRouteArgs(),
      );
      return OrderSuccessScreen(
        key: args.key,
        orderCreateModel: args.orderCreateModel,
      );
    },
  );
}

class OrderSuccessRouteArgs {
  const OrderSuccessRouteArgs({this.key, this.orderCreateModel});

  final Key? key;

  final OrderCreateModel? orderCreateModel;

  @override
  String toString() {
    return 'OrderSuccessRouteArgs{key: $key, orderCreateModel: $orderCreateModel}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderSuccessRouteArgs) return false;
    return key == other.key && orderCreateModel == other.orderCreateModel;
  }

  @override
  int get hashCode => key.hashCode ^ orderCreateModel.hashCode;
}

/// generated route for
/// [OrdersListScreen]
class OrdersListRoute extends PageRouteInfo<void> {
  const OrdersListRoute({List<PageRouteInfo>? children})
    : super(OrdersListRoute.name, initialChildren: children);

  static const String name = 'OrdersListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OrdersListScreen();
    },
  );
}

/// generated route for
/// [ProductDetailsScreen]
class ProductDetailsRoute extends PageRouteInfo<ProductDetailsRouteArgs> {
  ProductDetailsRoute({
    Key? key,
    required int productId,
    List<PageRouteInfo>? children,
  }) : super(
         ProductDetailsRoute.name,
         args: ProductDetailsRouteArgs(key: key, productId: productId),
         initialChildren: children,
       );

  static const String name = 'ProductDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailsRouteArgs>();
      return ProductDetailsScreen(key: args.key, productId: args.productId);
    },
  );
}

class ProductDetailsRouteArgs {
  const ProductDetailsRouteArgs({this.key, required this.productId});

  final Key? key;

  final int productId;

  @override
  String toString() {
    return 'ProductDetailsRouteArgs{key: $key, productId: $productId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductDetailsRouteArgs) return false;
    return key == other.key && productId == other.productId;
  }

  @override
  int get hashCode => key.hashCode ^ productId.hashCode;
}

/// generated route for
/// [ProductsScreen]
class ProductsRoute extends PageRouteInfo<void> {
  const ProductsRoute({List<PageRouteInfo>? children})
    : super(ProductsRoute.name, initialChildren: children);

  static const String name = 'ProductsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProductsScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({Key? key, List<PageRouteInfo>? children})
    : super(
        ProfileRoute.name,
        args: ProfileRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileRouteArgs>(
        orElse: () => const ProfileRouteArgs(),
      );
      return ProfileScreen(key: args.key);
    },
  );
}

class ProfileRouteArgs {
  const ProfileRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProfileRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [UserDetailsScreen]
class UserDetailsRoute extends PageRouteInfo<UserDetailsRouteArgs> {
  UserDetailsRoute({Key? key, int userId = 0, List<PageRouteInfo>? children})
    : super(
        UserDetailsRoute.name,
        args: UserDetailsRouteArgs(key: key, userId: userId),
        initialChildren: children,
      );

  static const String name = 'UserDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserDetailsRouteArgs>(
        orElse: () => const UserDetailsRouteArgs(),
      );
      return UserDetailsScreen(key: args.key, userId: args.userId);
    },
  );
}

class UserDetailsRouteArgs {
  const UserDetailsRouteArgs({this.key, this.userId = 0});

  final Key? key;

  final int userId;

  @override
  String toString() {
    return 'UserDetailsRouteArgs{key: $key, userId: $userId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserDetailsRouteArgs) return false;
    return key == other.key && userId == other.userId;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode;
}

/// generated route for
/// [WishlistScreen]
class WishlistRoute extends PageRouteInfo<void> {
  const WishlistRoute({List<PageRouteInfo>? children})
    : super(WishlistRoute.name, initialChildren: children);

  static const String name = 'WishlistRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WishlistScreen();
    },
  );
}

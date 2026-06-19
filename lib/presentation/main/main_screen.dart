// ignore_for_file: must_be_immutable
import 'package:auto_route/auto_route.dart';
import 'package:e_comm_user/bloc/cart/cart_bloc.dart';
import 'package:e_comm_user/bloc/cart/cart_event.dart';
import 'package:e_comm_user/bloc/cart/cart_state.dart';
import 'package:e_comm_user/bloc/navigation/navigation_bloc.dart';
import 'package:e_comm_user/bloc/navigation/navigation_event.dart';
import 'package:e_comm_user/bloc/navigation/navigation_state.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_bloc.dart';
import 'package:e_comm_user/bloc/wishlist/wishlist_state.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/presentation/account/account_screen.dart';
import 'package:e_comm_user/presentation/cart/cart_screen.dart';
import 'package:e_comm_user/presentation/categories/categories_screen.dart';
import 'package:e_comm_user/presentation/home/home_screen.dart';
import 'package:e_comm_user/presentation/wishlist/wishlist_screen.dart';
import 'package:e_comm_user/utils/assets.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_alert.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
    MainScreen({super.key,this.selectedIndex = 0 });
  int selectedIndex  ;
  static const int cartTabIndex = 3;


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final NavigationBloc navigationBloc = getIt<NavigationBloc>();
  // final NavigationBloc navigationBloc = NavigationBloc();
  final CartBloc cartBloc = getIt<CartBloc>();
  final WishlistBloc wishlistBloc = getIt<WishlistBloc>();

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    WishlistScreen(),
    CartScreen(),
    AccountScreen(),
  ];
  @override
  void initState() {
    super.initState();
    navigationBloc.add(
      NavigationTabChangedEvent(
        widget.selectedIndex,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => navigationBloc),
        BlocProvider.value(value: cartBloc),
        BlocProvider.value(value: wishlistBloc),
      ],
      child: BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
          if (state is NavigationTabChangedState && state.currentIndex == MainScreen.cartTabIndex) {
            cartBloc.add(GetCartItemsEvent());
          }
        },
        child: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            final currentIndex =
                state is NavigationTabChangedState ? state.currentIndex : 0;

            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {

                if (currentIndex != 0) {
                  navigationBloc.add(NavigationTabChangedEvent(0));
                  return;
                }

                final shouldExit = await CustomPopupDialog.show(
                  context,
                  title: exitApp,
                  description: areYouSureExit,
                  positiveButtonText: exit,
                  negativeButtonText: cancel,
                  icon: Icon(
                    Icons.logout,
                    color: errorColor,
                    size: 45,
                  ),
                );

                if (shouldExit == true) {
                  SystemNavigator.pop();
                }
              },
              child: Scaffold(
                body: IndexedStack(
                  index: currentIndex,
                  children: _screens,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: whiteColor,
                  currentIndex: currentIndex,
                  selectedItemColor: primaryColor,
                  unselectedItemColor: greyColor,
                  onTap: (index) {
                    navigationBloc.add(NavigationTabChangedEvent(index));
                  },
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        currentIndex == 0
                            ? homeSelectedIcon
                            : homeUnselectedIcon,
                      ),
                      label: bottomHome,
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        currentIndex == 1
                            ? categorySelectedIcon
                            : categoryUnselectedIcon,
                      ),
                      label: bottomCategories,
                    ),
                    BottomNavigationBarItem(
                      icon: BlocBuilder<WishlistBloc,WishlistState>(
                        builder: (context, state) {
                          final wishlistItems = wishlistBloc.currentWishlistItems;
                          final totalWishlistItems = wishlistItems.length;
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SvgPicture.asset(
                                currentIndex == 2
                                    ? wishlistSelectedIcon
                                    : wishlistUnselectedIcon,
                              ),
                              if (totalWishlistItems > 0)
                                Positioned(
                                  right: -8,
                                  top: -7,
                                  child: Container(
                                    padding: EdgeInsets.all(1.w),
                                    decoration: BoxDecoration(
                                      color: errorColor,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints:
                                    const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: CustomText(
                                      text:totalWishlistItems.toString(),
                                      color: whiteColor,
                                      fontSize: 12.px,
                                      textAlign:
                                      TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      label: bottomWishList,
                    ),
                    BottomNavigationBarItem(
                      icon: BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            final cartItems = context.read<CartBloc>().currentCartItems;
                            final totalQuantity = cartItems.fold<int>(
                              0, (sum, item) => sum + (item.quantity ?? 0));
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SvgPicture.asset(
                                currentIndex == 3
                                    ? cartSelectedIcon
                                    : cartUnselectedIcon,
                              ),
                              if (totalQuantity > 0)
                                Positioned(
                                  right: -8,
                                  top: -7,
                                  child: Container(
                                    padding: EdgeInsets.all(1.w),
                                    decoration: BoxDecoration(
                                      color: errorColor,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: CustomText(
                                      text: totalQuantity.toString(),
                                      color: whiteColor,
                                      fontSize: 12.px,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }
                      ),
                      label: bottomCart,
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        currentIndex == 4
                            ? accountSelectedIcon
                            : accountUnselectedIcon,
                      ),
                      label: bottomAccount,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_comm_user/bloc/category/category_bloc.dart';
import 'package:e_comm_user/bloc/category/category_event.dart';
import 'package:e_comm_user/bloc/category/category_state.dart';
import 'package:e_comm_user/bloc/home/home_bloc.dart';
import 'package:e_comm_user/bloc/home/home_event.dart';
import 'package:e_comm_user/bloc/home/home_state.dart';
import 'package:e_comm_user/bloc/navigation/navigation_bloc.dart';
import 'package:e_comm_user/bloc/product/product_bloc.dart';
import 'package:e_comm_user/bloc/product/product_event.dart';
import 'package:e_comm_user/bloc/search_filed/search_field_bloc.dart';
import 'package:e_comm_user/bloc/search_filed/search_field_event.dart';
import 'package:e_comm_user/bloc/search_filed/search_field_state.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/product_model.dart';
import 'package:e_comm_user/presentation/arrow.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/assets.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/constants.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:e_comm_user/widgets/error_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  final String page = '/homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductBloc productBloc = getIt<ProductBloc>();
  CategoryBloc categoryBloc = getIt<CategoryBloc>();
  NavigationBloc navigationBloc = getIt<NavigationBloc>();
  HomeBloc homeBloc = getIt<HomeBloc>();
  ProductResponseModel? productResponseModel;
  List<String> homeItems = [];
  var searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  int? selectedCategoryId;
  final minController = TextEditingController();
  final maxController = TextEditingController();
  var prefs = getIt<SharedPreferences>();
  bool isLoggedIn = false;
  int activeIndex = 0;
  String removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }
@override
  void initState() {
    super.initState();
    pageNo = 1;
    hasMoreData = true;
    isLoadingMore = false;
    productBloc.add(ProductListEvent(pageNo, limit, ''));
    categoryBloc.add(const TopCategoryLoadEvent());
    scrollController.addListener(onScroll);
    homeBloc.add(GetHomeEvent(0));
    getUpdatedAddress();
  }
  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    productBloc.close();
    categoryBloc.close();
    super.dispose();
  }
  onScroll(){
    if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200
        && !isLoadingMore && hasMoreData){
      isLoadingMore = true;
      pageNo++;
      productBloc.add(ProductListEvent(pageNo, limit, searchController.text, selectedCategoryId));
    }
  }
  getUpdatedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final address = prefs.getString(SharedPrefHelper.userAddress) ?? "";
    addressStreamController.add(address);
  }

  @override
  Widget build(BuildContext context) {
    getUpdatedAddress();
    isLoggedIn = prefs.getBool(SharedPrefHelper.isLoginPref) ?? false;
    log("isLoggedIn: $isLoggedIn");
    final double topPadding = MediaQuery.of(context).padding.top;
    final addressBar = BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {

        if (state is HomeLoaded) {
          final homeResponseModel = state.homeResponseModel;
          final home = homeResponseModel.data;
          final delivery = home?.delivery_address;
          final address = (delivery == null) ? ""
              :[ delivery.address_line, delivery.city,
            delivery.state, delivery.country, delivery.pincode,
          ].where((e) => e != null && e.isNotEmpty).join(", ");
          final hasAddress = isLoggedIn && address.trim().isNotEmpty;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                // Icon(
                //   Icons.location_on_outlined,
                //   color: greyColor.withValues(alpha: .6),
                //   size: 18.px,
                // ),
                // const SizedBox(width: 4),
                if (hasAddress)
                  Expanded(
                    child: StreamBuilder<String>(
                      initialData: address,
                      stream: deliveryAddressStream,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? CustomText(
                          text: '📍 ${snapshot.data}' ?? '',
                          fontSize: 12.px,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          overflow: TextOverflow.ellipsis,
                        )
                            : CustomText(
                          text: snapshot.error?.toString() ?? '',
                          fontSize: 20.px,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        );
                      },
                    ),
                  )
                else ...[
                  // CustomText(text: '📍$noAddress', fontSize: 12.px),
                  // const Spacer(),
                  // TextButton(
                  //   style: TextButton.styleFrom(
                  //     padding: EdgeInsets.zero,
                  //     minimumSize: Size.zero,
                  //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //   ),
                  //   onPressed: () {
                  //     if(isLoggedIn){
                  //       getIt<AppRoutes>().push(CreateAddressRoute());
                  //     }else{
                  //       Functions.showCustomSnackBar(context, message: loginToAddress);
                  //     }
                  //   },
                  //   child: CustomText(
                  //     text: addAddress,
                  //     style: CustomTextStyle.bold,
                  //     color: primaryColor,
                  //     fontSize: 12.px,
                  //   ),
                  // ),
                ],
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
    return Scaffold(
      backgroundColor: whiteColor,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => productBloc),
          BlocProvider(create: (context) => categoryBloc),
          BlocProvider(create: (context) => navigationBloc),
          // BlocProvider(create: (context) => wishlistBloc),
          BlocProvider(create: (context) => homeBloc),
          // BlocProvider(create: (context) => searchBloc),
          BlocProvider(create: (context) => SearchBloc(
            allItems: homeItems, // use same list for suggestions if needed
            hints: homeItems,    // rotating hints come from API
          )),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            homeBloc.add(GetHomeEvent(selectedCategoryId ?? 0));
            categoryBloc.add(const TopCategoryLoadEvent());
            productBloc.add(ProductListEvent(1, limit, searchController.text, selectedCategoryId));
          },
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: FlipkartAppBarDelegate(
                  topPadding: topPadding,
                  addressBar: addressBar,
                  appBar: AppBar(
                    primary: false,
                    backgroundColor: whiteColor,
                    surfaceTintColor: whiteColor,
                    centerTitle: true,
                    leading: Container(
                      transform: Matrix4.translationValues(0, 2.h, 0),
                      width: 5.h,
                      height: 5.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(appLogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: CustomText(text: appName, fontSize: 20.sp,),
                    actions: [
                      Visibility(
                        visible: true,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ArrowPuzzleApp()));
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                  searchBar: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: BlocBuilder<SearchBloc, SearchState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  getIt<AppRoutes>().push(ProductsRoute());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1.h),
                                    border: Border.all(color: textFieldDisableColor),
                                  ),
                                  padding: EdgeInsets.all(1.3.h),
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Icon(Icons.search,color: textFieldDisableColor),
                                      ValueListenableBuilder(
                                        valueListenable: searchController,
                                        builder: (_, value, __) {
                                          return Visibility(
                                            visible: (value.text.isEmpty),
                                            child: IgnorePointer(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 13.w, top: 0.h),
                                                child: AnimatedSwitcher(
                                                  duration: const Duration(milliseconds: 300),
                                                  child: CustomText(
                                                    text: state.hint,
                                                    key: ValueKey(state.hint),
                                                    color: greyColor.withValues(alpha: .5),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 2.w),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, categoryState) {
                    if (categoryState is CategorySuccessState) {
                      return Container(
                        height: 12.h,
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: categoryState.categories.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            /// Categories
                            if (index < categoryState.categories.length) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                context.read<SearchBloc>().add(
                                  UpdateHintsEvent(
                                    categoryState.categories
                                        .map((e) => e.category_name ?? '')
                                        .where((e) => e.isNotEmpty && e.toLowerCase().trim() != 'for you',)
                                        .toList(),
                                  ),
                                );
                              });
                              final category = categoryState.categories[index];
                              final isSelected = categoryState.selectedCategoryId == category.category_id;
                              final imageUrl =
                              (category.category_name?.toLowerCase().trim() == 'for you')
                                  ? 'https://cdn-icons-png.flaticon.com/512/3159/3159002.png'
                                  : (category.images?.isNotEmpty == true
                                  ? category.images!.first.image_url ?? ''
                                  : '');
                              return GestureDetector(
                                onTap: () {
                                  categoryBloc.add(
                                    TopCategorySelectEvent(
                                      categoryId: category.category_id,
                                      categoryName:
                                      category.category_name ?? 'For You',
                                    ),
                                  );
                                  selectedCategoryId = category.category_id;
                                  pageNo = 1;
                                  productBloc.add(ProductListEvent(pageNo, limit, '',selectedCategoryId));
                                  homeBloc.add(GetHomeEvent(selectedCategoryId ?? 0));
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      height: 6.h,
                                      width: 6.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(1.h),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(1.h),
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          placeholder: (context, url) => SizedBox(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: .8.h),

                                    CustomText(
                                      text: category.category_name ?? allText,
                                      color: isSelected
                                          ? primaryColor
                                          : blackColor,
                                      fontSize: 12.px,
                                      style: isSelected
                                          ? CustomTextStyle.bold
                                          : CustomTextStyle.medium,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              );
                            }

                            /// View All Button
                            return GestureDetector(
                              onTap: () {
                                getIt<AppRoutes>().replaceAll([
                                  MainRoute(key: UniqueKey(), selectedIndex: 1),
                                ]);
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: .5.h),
                                  Image.asset(viewAllIcon,height: 4.5.h),
                                  SizedBox(height: 1.7.h),
                                  CustomText(
                                    text: viewAll,
                                    color: primaryColor,
                                    fontSize: 14.px,
                                    style: CustomTextStyle.bold,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height/1.5,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (state is HomeError) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height/1.5,
                        child: Center(
                          child: CustomText(
                            text: state.message,
                          ),
                        ),
                      );
                    }

                    if (state is HomeLoaded) {
                      homeResponseModel = state.homeResponseModel;
                      final home = homeResponseModel.data;
                      final delivery = home?.delivery_address;
                      final address = (delivery == null) ? ""
                          :[ delivery.address_line, delivery.city,
                        delivery.state, delivery.country, delivery.pincode,
                      ].where((e) => e != null && e.isNotEmpty).join(", ");
                      // final hasAddress = isLoggedIn && address.trim().isNotEmpty;
                      final activeIndex = state.bannerIndex;
                      final banners = state.homeResponseModel.data?.banners ?? [];

                      final displayBanners = banners.length > 5
                          ? banners.sublist(0, 5)
                          : banners;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            /// Banner
                            Visibility(
                              visible: home?.banners?.isNotEmpty ?? false,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 1.h),
                                child: Column(
                                  children: [
                                    CarouselSlider(
                                      items: displayBanners.asMap().entries.map((entry) {
                                            final index = entry.key;
                                            final banner = entry.value;
                                              return GestureDetector(
                                                onTap: () {
                                                  getIt<AppRoutes>().push(
                                                    OffersRoute(categoryId: banner.category_id ?? 1),
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.primaries[index % Colors.primaries.length].withValues(alpha: .2),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      // Top Left Logo + App Name
                                                      Positioned(
                                                        top: 1.h,
                                                        left: 2.w,
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(12),
                                                              child: Image.asset(
                                                                appLogo,
                                                                width: 2.h,
                                                                height: 40,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                            SizedBox(width: 2.w),
                                                            CustomText(
                                                              text: appName,
                                                              fontSize: 14.px,
                                                              style: CustomTextStyle.bold,
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Main Content
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                          left: 2.w,
                                                          right: 3.w,
                                                          top: 1.h,
                                                          bottom: 1.h,
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            CustomText(
                                                              text: banner.title ?? '',
                                                              fontSize: 20.px,
                                                              style: CustomTextStyle.bold,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            SizedBox(height: .5.h),
                                                            CustomText(
                                                              text:removeHtmlTags(banner.description ?? ''),
                                                              fontSize: 12.px,
                                                              style: CustomTextStyle.regular,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Product/Banner Image
                                                      Positioned(
                                                        right: 2.w,
                                                        bottom: -2.h,
                                                        child: Hero(
                                                          tag: "banner_${banner.bannerId}",
                                                          child: Image.network(
                                                            banner.image_url ?? '',
                                                            width: 10.w,
                                                            height: 10.h,
                                                            fit: BoxFit.contain,
                                                            errorBuilder: (_, __, ___) =>
                                                            const SizedBox.shrink(),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                      ).toList(),
                                      options: CarouselOptions(
                                        height: 20.h,
                                        aspectRatio: 16 / 9,
                                        viewportFraction: 1,
                                        autoPlay: (home?.banners?.length ?? 0) > 1,
                                        enlargeCenterPage: false,
                                        onPageChanged: (index, reason) {
                                           homeBloc.add(BannerPageChangedEvent(index));
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Visibility(
                                      visible: (home?.banners?.length ?? 0) > 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(
                                          displayBanners.length,
                                              (index) {
                                            final isActive = index == activeIndex;
                                            return Flexible(
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 300),
                                                margin: EdgeInsets.symmetric(horizontal: 3),
                                                width: isActive ? 4.w : 1.5.w,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  color: isActive ? primaryColor : primaryColor.withValues(alpha: .5),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /// Trending
                            Visibility(
                              visible: home?.trending_products?.isNotEmpty ?? false,
                              child: _productSection(
                                title: "Trending Products",
                                products: home?.trending_products ?? [],
                              ),
                            ),

                            /// Featured
                            Visibility(
                              visible: home?.featured_products?.isNotEmpty ?? false,
                              child: _productSection(
                                title: "Featured Products",
                                products: home?.featured_products ?? [],
                              ),
                            ),
                            SizedBox(height: 24.px),
                            /// Popular
                            Visibility(
                              visible: home?.popular_products?.isNotEmpty ?? false,
                              child: _productSection(
                                title: "Popular Products",
                                products: home?.popular_products ?? [],
                              ),
                            ),
                            SizedBox(height: 24.px),
                            /// New Arrivals
                            Visibility(
                              visible: home?.new_arrivals?.isNotEmpty ?? false,
                              child: _productSection(
                                title: "New Arrivals",
                                products: home?.new_arrivals ?? [],
                              ),
                            ),
                            SizedBox(height: 24.px),
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(
      String title,
      ) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [

        CustomText(
          text: title,
          fontSize: 18.px,
          style: CustomTextStyle.bold,
        ),

        Visibility(
          visible: false,
          child: GestureDetector(
            onTap: () {
              getIt<AppRoutes>().push(ProductsRoute());
            },
            child: CustomText(
              text: viewAll,
              color: primaryColor,
              fontSize: 14.px,
              style: CustomTextStyle.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _productSection({
    required String title,
    required List<Product> products,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),
        _sectionTitle(title),
        SizedBox(height: 1.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.62,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder:(_, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                getIt<AppRoutes>().push(ProductDetailsRoute(productId: product.id ?? 0));
              },
              child: _productCard(product),
            );
          },
        ),
      ],
    );
  }
  Widget _productCard(Product product) {
    final imageUrl = product.images!.isNotEmpty
        ? product.images?.first.image_url : '';
    return Container(
      width: 170.px,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft:Radius.circular(1.h),
                topRight:Radius.circular(1.h),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(1.h)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: ErrorImageWidget(),
                  ),
                )
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10.px),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: product.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyle.bold,
                ),
                SizedBox(height: 6.px),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text:'₹${Functions.formatPrice(product.price)}',
                        style: CustomTextStyle.bold,
                        fontSize: 16,
                        color: blackColor.withValues(alpha: .2),
                        decoration: TextDecoration.lineThrough,
                        decorationColor: blackColor.withValues(alpha: .2),
                      ),
                    ),
                    Expanded(
                      child: CustomText(
                        text:'₹${Functions.formatPrice(product.discount_price)}',
                        style: CustomTextStyle.bold,
                        fontSize: 16,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    double rating = Functions.getRating(product.id ?? 0);

                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: successColor,
                      size: 18,
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FlipkartAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget appBar;
  final Widget addressBar;
  final Widget searchBar;
  final double topPadding;

  FlipkartAppBarDelegate({
    required this.appBar,
    required this.addressBar,
    required this.searchBar,
    required this.topPadding,
  });

  @override
  double get minExtent => 80.0 + topPadding;

  @override
  double get maxExtent => 56.0 + 30.0 + 80.0 + topPadding;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    const double appBarHeight = 56.0;
    const double addressBarHeight = 30.0;
    const double collapsingHeight = appBarHeight + addressBarHeight;
    final double collapseProgress = (shrinkOffset / collapsingHeight).clamp(0.0, 1.0);
    final double opacity = 1.0 - collapseProgress;

    return Container(
      color: whiteColor,
      child: Column(
        children: [
          SizedBox(height: topPadding),
          Expanded(
            child: ClipRect(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: collapsingHeight,
                    child: Opacity(
                      opacity: opacity,
                      child: IgnorePointer(
                        ignoring: opacity < 0.1,
                        child: Column(
                          children: [
                            SizedBox(height: appBarHeight, child: appBar),
                            SizedBox(height: addressBarHeight, child: addressBar),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80.0,
                    child: searchBar,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant FlipkartAppBarDelegate oldDelegate) {
    return appBar != oldDelegate.appBar ||
        addressBar != oldDelegate.addressBar ||
        searchBar != oldDelegate.searchBar ||
        topPadding != oldDelegate.topPadding;
  }
}
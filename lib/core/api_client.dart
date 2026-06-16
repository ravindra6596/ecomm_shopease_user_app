import 'package:dio/dio.dart';
import 'package:e_comm_user/models/address_request_model.dart';
import 'package:e_comm_user/models/address_response_model.dart';
import 'package:e_comm_user/models/cart_model.dart';
import 'package:e_comm_user/models/category_model.dart';
import 'package:e_comm_user/models/chatbot_response_model.dart';
import 'package:e_comm_user/models/home_response_model.dart';
import 'package:e_comm_user/models/login_request_model.dart';
import 'package:e_comm_user/models/login_response_model.dart';
import 'package:e_comm_user/models/logout_response_model.dart';
import 'package:e_comm_user/models/order_request_model.dart';
import 'package:e_comm_user/models/order_response_model.dart';
import 'package:e_comm_user/models/product_model.dart';
import 'package:e_comm_user/models/profile_response_model.dart';
import 'package:e_comm_user/models/register_request_model.dart';
import 'package:e_comm_user/models/user_details_model.dart';
import 'package:e_comm_user/models/user_model.dart';
import 'package:e_comm_user/models/wishlist_model.dart';
import 'package:e_comm_user/utils/apis.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio) = _ApiClient;

  // home
  @GET(ApiConstants.home)
  Future<HomeResponseModel> getHome(
      @Query(ApiConstants.categoryId) int? categoryId,
  );
  // user list
  @GET(ApiConstants.userList)
  Future<UserResponseModel> getUserList(
    @Query(ApiConstants.page) int page,
    @Query(ApiConstants.limit) int limit,
  );

  // register user
  @POST(ApiConstants.registerUser)
  Future<LoginResponseModel> registerUser(
      @Body() RegisterRequestModel registerRequestModel);

  // login user
  @POST(ApiConstants.loginUser)
  Future<LoginResponseModel> loginUser(
      @Body() LoginRequestModel loginRequestModel);

  // login user
  @POST(ApiConstants.logoutUser)
  Future<LogoutResponseModel> logoutUser(
      @Header('Authorization') String accessToken);

  // single user
  @GET(ApiConstants.getUserId)
  Future<UserDetailsModel> getUserDetails(
    @Path(ApiConstants.userId) int userId,
  );

  // products list
  @GET(ApiConstants.productsList)
  Future<ProductResponseModel> getProductsList(
    @Query(ApiConstants.page) int page,
    @Query(ApiConstants.limit) int limit,
    @Query(ApiConstants.search) String search,
    @Query(ApiConstants.categoryId) int? categoryId,
    @Query(ApiConstants.minPrice) double? minPrice,
    @Query(ApiConstants.maxPrice) double? maxPrice,
    @Query(ApiConstants.sortBy) String? sortBy,
    @Query(ApiConstants.order) String? order,
  );

  // product details
  @GET(ApiConstants.productDetails)
  Future<ProductDetailsResponseModel> getProductDetails(
    @Path(ApiConstants.id) int id,
  );

  // top categories
  @GET(ApiConstants.topCategories)
  Future<TopCategoryResponseModel> getTopCategories();

  // list categories
  @GET(ApiConstants.categoriesList)
  Future<CategoriesResponseModel> getCategories(
    @Query(ApiConstants.page) int page,
    @Query(ApiConstants.limit) int limit,
    @Query(ApiConstants.categoryId) int? categoryId,
  );

  // category details
  @GET(ApiConstants.categoriesDetails)
  Future<CategoryDetailsResponseModel> getCategoryDetails(
    @Path(ApiConstants.id) int id,
  );

  // add to cart
  @POST(ApiConstants.cart)
  Future<AddToCartResponseModel> addToCart(
    @Body() AddToCartRequestModel addToCartRequestModel,
  );

  // get cart items
  @GET(ApiConstants.cart)
  Future<CartResponseModel> getCartItems();

  // update cart quantity
  @PATCH('${ApiConstants.cart}/{${ApiConstants.cartItemId}}')
  Future<UpdateQuantityResponseModel> updateCartQuantity(
    @Path(ApiConstants.cartItemId) int cartItemId,
    @Body() UpdateQuantityRequestModel updateQuantityRequestModel,
  );

  // remove from cart
  @DELETE('${ApiConstants.cart}/{${ApiConstants.cartItemId}}')
  Future<dynamic> removeFromCart(
    @Path(ApiConstants.cartItemId) int cartItemId,
  );

  // clear cart
  @DELETE(ApiConstants.cart)
  Future<dynamic> clearCart();

  // address list
  @GET(ApiConstants.addressList)
  Future<AddressResponseModel> getAddressList();

  // address details
  @GET(ApiConstants.addressDetails)
  Future<AddressDetailsResponseModel> getAddressDetails(
    @Path(ApiConstants.id) int id,
  );

  // create address
  @POST(ApiConstants.addressList)
  Future<AddressCreatedModel> createAddress(
      @Body() AddressRequestModel addressRequestModel);

  // update address
  @PATCH(ApiConstants.addressDetails)
  Future<AddressUpdatedModel> updateAddress(
      @Path(ApiConstants.id) int cartItemId,
      @Body() AddressRequestModel addressRequestModel);
// delete address
  // address details
  @DELETE(ApiConstants.addressDetails)
  Future<AddressUpdatedModel> deleteAddress(
      @Path(ApiConstants.id) int id,
      );
  // create order
  @POST(ApiConstants.orderList)
  Future<OrderCreateModel> createOrder(
      @Body() OrderRequestModel orderRequestModel);

  @GET(ApiConstants.orderList)
  Future<OrderResponseModel> getOrdersList(
    @Query(ApiConstants.page) int page,
    @Query(ApiConstants.limit) int limit,
    @Query(ApiConstants.search) String search,
    @Query(ApiConstants.paymentMethod) String? paymentMethod,
    @Query(ApiConstants.orderStatus) String? orderStatus,
    @Query(ApiConstants.sortBy) String? sortBy,
    @Query(ApiConstants.order) String? order,
  );

  // order details
  @GET(ApiConstants.orderDetails)
  Future<OrderDetailsResponseModel> getOrderDetails(
    @Path(ApiConstants.id) int id,
  );

  // order details
  @GET(ApiConstants.orderInvoice)
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> getOrderInvoice(
      @Path(ApiConstants.id) int id,
      );

  @PATCH(ApiConstants.orderCancel)
  Future<OrderDetailsResponseModel> cancelOrder(
    @Path(ApiConstants.id) int id,
  );
  // update order address
  @PATCH(ApiConstants.orderUpdateAddress)
  Future<AddressUpdatedModel> updateOrderAddress(
      @Path(ApiConstants.id) int id,
      @Body() UpdateOrderAddressRequest updateOrderAddressRequest);
  // profile
  @GET(ApiConstants.profile)
  Future<ProfileResponseModel> getProfile();

  @PATCH(ApiConstants.profile)
  Future<ProfileResponseModel> updateProfile(
    @Body() UpdateProfileRequestModel request,
  );

  @POST(ApiConstants.wishlist)
  Future<AddToWishlistResponseModel> addToWishlist(
    @Body() AddToWishlistRequestModel request,
  );

  @GET(ApiConstants.wishlist)
  Future<WishlistResponseModel> getWishlistItems();

  @DELETE(ApiConstants.wishListRemove)
  Future<dynamic> removeFromWishlist(
    @Path('id') int wishlistItemId,
  );

  @DELETE(ApiConstants.clearWishlist)
  Future<dynamic> clearWishlist();

  @POST(ApiConstants.chatbot)
  Future<ChatbotResponseModel> chatBot(
    @Body() Map<String, dynamic> body,
  );

  @GET("/chatbot")
  Future<ChatbotHistoryResponseModel> getChatHistory();
}

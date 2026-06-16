import 'package:e_comm_user/di/configure.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SharedPrefHelper {
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String userIdKey = 'userId';
  static const String userEmailKey = 'userEmail';
  static const String userRoleKey = 'userRole';
  static const String onboardingCompletedKey = 'onboardingCompleted';
  static const String guestIdKey = "guestId";
  static const String isLoginPref = 'isLoginPref';
  static const String guestUser = 'guestUser';
  static const String rememberMeKey = 'rememberMeKey';
  static const String savedEmailKey = 'savedEmailKey';
  static const String savedPasswordKey = 'savedPasswordKey';

  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessTokenKey, accessToken);
    await prefs.setString(refreshTokenKey, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshTokenKey);
  }

  static Future<void> saveUserInfo(int userId, String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userIdKey, userId);
    await prefs.setString(userEmailKey, email);
    await prefs.setString(userRoleKey, role);
  }

  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(userIdKey);
    final email = prefs.getString(userEmailKey);
    final role = prefs.getString(userRoleKey);
    
    if (userId != null && email != null && role != null) {
      return {
        'userId': userId,
        'email': email,
        'role': role,
      };
    }
    return null;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessTokenKey);
    await prefs.remove(refreshTokenKey);
    await prefs.remove(userIdKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userRoleKey);
    await prefs.setBool(isLoginPref, false);
    await prefs.setBool(guestUser, false);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingCompletedKey, completed);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingCompletedKey) ?? false;
  }
  static Future<void> saveGuestId(String guestId) async {
    final prefs =  await SharedPreferences.getInstance();

    await prefs.setString(guestIdKey,guestId);
  }
  static Future<String> getGuestId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(guestIdKey) ?? '';
  }
  static Future<void> generateGuestId() async {
    final prefs =  await SharedPreferences.getInstance();
    final existingGuestId = prefs.getString(guestIdKey);
    if (existingGuestId != null && existingGuestId.isNotEmpty) {
      return;
    }
    final guestId = const Uuid().v4();
    await prefs.setString(guestIdKey, guestId);
  }


  static Future<void> saveRememberMe({
    required bool rememberMe,
    required String email,
    required String password,
  }) async {
    final prefs = getIt<SharedPreferences>();

    await prefs.setBool(rememberMeKey, rememberMe);

    if (rememberMe) {
      await prefs.setString(savedEmailKey, email);
      await prefs.setString(savedPasswordKey, password);
    } else {
      await prefs.remove(savedEmailKey);
      await prefs.remove(savedPasswordKey);
    }
  }

  static Future<Map<String, dynamic>> getRememberMeData() async {
    final prefs = getIt<SharedPreferences>();

    return {
      'rememberMe': prefs.getBool(rememberMeKey) ?? false,
      'email': prefs.getString(savedEmailKey) ?? '',
      'password': prefs.getString(savedPasswordKey) ?? '',
    };
  }
}

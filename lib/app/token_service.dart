import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static String? accessToken;
  static String? refreshToken;
  static String? activeBranchId; // ✅ NEW

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  static bool get isLoggedIn => accessToken != null;

  static void setActiveBranch(String branchId) {
    activeBranchId = branchId;
  }

  /// 🔹 Load tokens on app start
  static Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_accessKey);
    refreshToken = prefs.getString(_refreshKey);
  }

  /// 🔹 Save tokens after login / refresh
  static Future<void> saveTokens({
    required String access,
    String? refresh,
  }) async {
    accessToken = access;
    if (refresh != null) {
      refreshToken = refresh;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    if (refresh != null) {
      await prefs.setString(_refreshKey, refresh);
    }
  }

  /// 🔹 Clear on logout / unauthorized
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = null;
    refreshToken = null;
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }
}

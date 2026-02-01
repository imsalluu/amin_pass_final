import 'package:amin_pass/app/token_service.dart';
import 'package:amin_pass/auth/repo/auth_repository.dart';
import 'package:amin_pass/auth/screen/login_screen.dart';
import 'package:amin_pass/common/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final AuthRepository _repo;
  AuthController(this._repo);

  final RxBool isLoading = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();

  // REGISTER
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    final res = await _repo.register(
      name: name,
      email: email,
      password: password,
    );
    isLoading.value = false;
    return res.isSuccess;
  }

  // LOGIN
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    final res = await _repo.login(
      email: email,
      password: password,
    );

    isLoading.value = false;
    if (!res.isSuccess) return false;

    final data = res.responseData!['data'];

    await TokenService.saveTokens(
      access: data['accessToken'],
      refresh: data['refreshToken'],
    );

    user.value = UserModel.fromJson(data['user']);
    return true;
  }

  // EMAIL OTP VERIFY
  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    isLoading.value = true;
    final res = await _repo.verifyOtp(email: email, otp: otp);
    isLoading.value = false;
    return res.isSuccess;
  }

  // LOGOUT
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await TokenService.clear();
      
      // 🔹 Clear GetStorage (for activeBranchId, etc)
      final storage = GetStorage();
      await storage.erase();
      
      user.value = null;
      debugPrint('✅ AuthController: Logout complete. Session cleared.');
      
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      debugPrint('❌ AuthController Logout Error: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<bool> tryRefreshToken() async {
    final refresh = TokenService.refreshToken;
    if (refresh == null) return false;

    final res = await _repo.refreshToken(refreshToken: refresh);

    if (!res.isSuccess) return false;

    final data = res.responseData!['data'];

    await TokenService.saveTokens(
      access: data['accessToken'],
      refresh: data['refreshToken'],
    );

    user.value = UserModel.fromJson(data['user']);
    return true;
  }

  // void logout(BuildContext context) async {
  //   await TokenService.clear();
  //   user.value = null;
  //
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (_) => const LoginScreen()),
  //         (_) => false,
  //   );
  // }
}

import 'package:get/get.dart';
import '../../core/services/network/network_client.dart';
import '../../app/urls.dart';
import '../../app/token_service.dart';

class ForgotPasswordOtpController extends GetxController {
  final NetworkClient _client;
  ForgotPasswordOtpController(this._client);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  String? resetToken;

  Future<bool> verifyForgotOtp({
    required String email,
    required String otp,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _client.postRequest(
      ApiUrls.verifyForgotOtp,
      skipAuth: true,
      body: {
        "email": email,
        "otp": otp,
      },
    );

    isLoading.value = false;

    if (!response.isSuccess) {
      errorMessage.value =
          response.errorMassage ?? "Invalid OTP";
      return false;
    }

    resetToken = response.responseData?['data']?['resetToken'];

    if (resetToken == null) {
      errorMessage.value = "Reset token not found";
      return false;
    }

    // 🔐 temporarily set resetToken as accessToken
    TokenService.saveTokens(
      access: resetToken!,
      refresh: null,
    );

    return true;
  }
}

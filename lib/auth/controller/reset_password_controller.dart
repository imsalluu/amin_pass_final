import 'package:get/get.dart';
import '../../core/services/network/network_client.dart';
import '../../app/urls.dart';
import '../../app/token_service.dart';

class ResetPasswordController extends GetxController {
  final NetworkClient _client;
  ResetPasswordController(this._client);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> resetPassword({
    required String newPassword,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _client.postRequest(
      ApiUrls.resetPassword,
      body: {
        "newPassword": newPassword,
      },
    );

    isLoading.value = false;

    if (!response.isSuccess) {
      errorMessage.value =
          response.errorMassage ?? "Password reset failed";
      return false;
    }

    // 🔐 reset complete → clear temporary reset token
    TokenService.clear();

    return true;
  }
}

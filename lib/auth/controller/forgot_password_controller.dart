import 'package:get/get.dart';
import '../../core/services/network/network_client.dart';
import '../../app/urls.dart';

class ForgotPasswordController extends GetxController {
  final NetworkClient _client;
  ForgotPasswordController(this._client);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> sendForgotPasswordOtp(String email) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _client.postRequest(
      ApiUrls.forgotPassword,
      body: {
        "email": email,
      },
    );

    isLoading.value = false;

    if (!response.isSuccess) {
      errorMessage.value =
          response.errorMassage ?? "Something went wrong";
      return false;
    }

    return true;
  }
}

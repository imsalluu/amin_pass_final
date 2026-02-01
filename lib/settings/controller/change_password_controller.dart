import 'package:get/get.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:amin_pass/app/urls.dart';

class ChangePasswordController extends GetxController {
  final NetworkClient client;
  ChangePasswordController(this.client);

  final isLoading = false.obs;

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;

    final res = await client.postRequest(
      ApiUrls.changePassword,
      body: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      },
    );

    isLoading.value = false;

    if (!res.isSuccess) {
      Get.snackbar('Error', res.errorMassage ?? 'Password change failed');
    }

    return res.isSuccess;
  }
}

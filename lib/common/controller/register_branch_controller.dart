import 'package:get/get.dart';
import 'package:amin_pass/app/urls.dart';
import '../../core/services/network/network_client.dart';

class RegisterBranchController extends GetxController {
  final NetworkClient _client;
  RegisterBranchController(this._client);

  final isLoading = false.obs;

  Future<bool> registerBranch({
    required String customerId,
    required String businessId,
    required String branchId,
  }) async {
    try {
      isLoading.value = true;

      final response = await _client.postRequest(
        ApiUrls.registerBranch,
        body: {
          "customerId": customerId,
          "businessId": businessId,
          "branchId": branchId,
        },
      );

      if (response.isSuccess) {
        return true;
      } else {
        Get.snackbar('Error', response.errorMassage ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

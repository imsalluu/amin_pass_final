import 'package:amin_pass/common/controller/shop_branch_controller.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:amin_pass/profile/controller/qr_code_controller.dart';
import 'package:get/get.dart';
import '../../auth/repo/auth_repository.dart';
import '../../app/token_service.dart';
import '../../common/model/user_model.dart';

class LoginController extends GetxController {
  final AuthRepository _repo;
  LoginController(this._repo);

  final RxBool isLoading = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxString errorMessage = ''.obs;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _repo.login(
      email: email,
      password: password,
    );

    isLoading.value = false;

    if (!response.isSuccess) {
      errorMessage.value = "Invalid email or password";
      return false;
    }

    final data = response.responseData!['data'];

    // save tokens
    await TokenService.saveTokens(
      access: data['accessToken'],
      refresh: data['refreshToken'],
    );

    // save user
    final userModel = UserModel.fromJson(data['user']);
    user.value = userModel;
    Get.find<ProfileController>().fetchProfile();
    
    if (Get.isRegistered<ShopBranchController>()) {
      Get.find<ShopBranchController>().fetchAllBranches();
    }

    if (Get.isRegistered<QrCodeController>()) {
      final qrController = Get.find<QrCodeController>();

      qrController.setQrData(
        code: userModel.qrCode ?? '',
        url: userModel.qrCodeUrl ?? '',
      );
    }
    return true;
  }

  bool get isEmailVerified => user.value?.isVerified ?? false;
}

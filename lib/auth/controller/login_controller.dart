import 'package:amin_pass/core/services/location_service.dart';
import 'package:amin_pass/core/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../../auth/repo/auth_repository.dart';
import '../../app/token_service.dart';
import '../../common/model/user_model.dart';
import '../../core/services/network/network_client.dart';
import '../../common/controller/shop_branch_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../profile/controller/qr_code_controller.dart';

class LoginController extends GetxController {
  final AuthRepository _repo;
  LoginController(this._repo);

  final RxBool isLoading = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxString errorMessage = ''.obs;

  Future<NetworkResponse> login({
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
      errorMessage.value = response.errorMassage ?? "Invalid email or password";
      return response;
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

    // Trigger FCM Token update
    FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        Get.find<NotificationService>().updateTokenOnServer(token);
      }
    });

    // Start Periodic Location Update
    Get.find<LocationService>().startPeriodicLocationUpdate();

    return response;
  }

  bool get isEmailVerified => user.value?.isVerified ?? false;
}

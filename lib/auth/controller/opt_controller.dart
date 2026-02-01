import 'package:get/get.dart';
import '../../auth/repo/auth_repository.dart';

class OtpController extends GetxController {
  final AuthRepository _repo;
  OtpController(this._repo);

  final RxBool isLoading = false.obs;

  Future<bool> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    isLoading.value = true;

    final res = await _repo.verifyOtp(
      email: email,
      otp: otp,
    );

    isLoading.value = false;
    return res.isSuccess;
  }
}

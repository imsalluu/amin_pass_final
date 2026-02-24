import 'package:amin_pass/app/token_service.dart';
import 'package:amin_pass/auth/controller/forgot_password_controller.dart';
import 'package:amin_pass/auth/controller/forgot_password_otp_controller.dart';
import 'package:amin_pass/auth/controller/login_controller.dart';
import 'package:amin_pass/auth/controller/opt_controller.dart';
import 'package:amin_pass/auth/controller/reset_password_controller.dart';
import 'package:amin_pass/auth/repo/auth_repository.dart';
import 'package:amin_pass/common/controller/auth_controller.dart';
import 'package:amin_pass/common/controller/register_branch_controller.dart';
import 'package:amin_pass/common/controller/shop_branch_controller.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:amin_pass/onBoarding/splash_screen.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:amin_pass/profile/controller/qr_code_controller.dart';
import 'package:amin_pass/profile/controller/transaction_history_controller.dart';
import 'package:amin_pass/rewards/controller/claim_reward_controller.dart';
import 'package:amin_pass/rewards/controller/earn_reward_controller.dart';
import 'package:amin_pass/settings/controller/change_password_controller.dart';
import 'package:amin_pass/profile/controller/edit_profile_controller.dart';
import 'package:amin_pass/home/controller/home_controller.dart';
import 'package:amin_pass/card/controller/loyalty_card_controller.dart';
import 'package:amin_pass/home/controller/notification_controller.dart';
import 'package:amin_pass/settings/controller/notification_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await TokenService.loadTokens();

    Get.put<NetworkClient>(
      NetworkClient(
        onUnAuthorize: () {
          TokenService.clear();
          Get.offAll(() => const SplashScreen());
        },
        commonHeaders: () => {
          "Content-Type": "application/json",
          if (TokenService.accessToken != null)
            "Authorization": "Bearer ${TokenService.accessToken}",
        },
      ),
      permanent: true,
    );

    // Auth Repository
    Get.put<AuthRepository>(AuthRepository(Get.find()), permanent: true);

    // Auth Controller
    Get.put<AuthController>(AuthController(Get.find()), permanent: true);
    Get.put<LoginController>(LoginController(Get.find()), permanent: true);

    Get.put<OtpController>(OtpController(Get.find()), permanent: true);

    Get.put<ForgotPasswordController>(
      ForgotPasswordController(Get.find()),
      permanent: true,
    );

    Get.put<ForgotPasswordOtpController>(
      ForgotPasswordOtpController(Get.find()),
      permanent: true,
    );

    Get.put<ResetPasswordController>(
      ResetPasswordController(Get.find()),
      permanent: true,
    );

    Get.lazyPut(() => ShopBranchController(Get.find()));

    Get.lazyPut<NotificationSettingsController>(
      () => NotificationSettingsController(Get.find()),
    );

    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(Get.find()),
    );

    Get.lazyPut<EditProfileController>(() => EditProfileController());
    Get.lazyPut<TransactionHistoryController>(
        () => TransactionHistoryController(Get.find()));

    Get.put<QrCodeController>(QrCodeController(), permanent: true);

    Get.put<ProfileController>(ProfileController(), permanent: true);
    Get.put(RegisterBranchController(Get.find()));


    Get.put<ClaimRewardController>(
      ClaimRewardController(Get.find()),
      permanent: true,
    );

    Get.put<EarnRewardController>(
      EarnRewardController(Get.find()),
      permanent: true,
    );

    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<LoyaltyCardController>(LoyaltyCardController(), permanent: true);
    Get.put<NotificationController>(NotificationController(), permanent: true);

  }
}

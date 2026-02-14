class ApiUrls {
  static const String baseUrl = "https://test13.fireai.agency/api";
  static const String mediaBaseUrl = "https://test13.fireai.agency/";

  // Auth
  static const String register = "$baseUrl/customer/register";
  static const String login = "$baseUrl/customer/auth/login";
  static const String otpVerify = "$baseUrl/customer/otp/verify";
  static const String refreshToken = "$baseUrl/customer/auth/refresh-token";
  static const String forgotPassword = "$baseUrl/customer/auth/forgot-password";
  static const String verifyForgotOtp =
      "$baseUrl/customer/auth/verify-forgot-password-otp";
  static const String resetPassword = "$baseUrl/customer/auth/reset-password";
  static const String getAllRegisterBranch = "$baseUrl/customer/my-branches";
  static const String switchBranch =
      '$baseUrl/customer/switch-branch';
  static const String getNotificationSettings =
      "$baseUrl/customer/notification-settings/me";

  static const String updateNotificationSettings =
      "$baseUrl/customer/notification-settings/update";

  static const String changePassword = "$baseUrl/customer/auth/change-password";
  static const String updateProfile =
      "$baseUrl/customer/update-profile";
  static const String myProfile = "$baseUrl/customer/profile/me";
  static const String registerBranch = "$baseUrl/customer/register-branch";
  static const String getMyEarnRewards =
      '$baseUrl/customer/earn-reward/my-earn-rewards';

  static const String getAllRewards =
      '$baseUrl/customer/claim-reward/all-rewards';
  static const String getClaimRewards =
      '$baseUrl/customer/claim-reward/all-rewards';

  static const String claimReward = "$baseUrl/customer/claim-reward/claim";
  static const String getCustomerActivity = "$baseUrl/customer/activity-history/my-activity";
  static const String getCardsByBusiness = "$baseUrl/customers/cards/business";
  static const String getTransactionHistory = "$baseUrl/customer/transaction-history/earned-history";
  static const String googleWalletLink = "$baseUrl/customer/wallet/google-wallet-link";
  static const String getMyAddedCards = "$baseUrl/customers/cards/my-cards";
}

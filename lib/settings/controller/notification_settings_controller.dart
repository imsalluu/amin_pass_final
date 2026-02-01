import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:amin_pass/settings/model/notification_settings_model.dart';
import 'package:amin_pass/app/urls.dart';

class NotificationSettingsController extends GetxController {
  final NetworkClient client;
  NotificationSettingsController(this.client);

  final isLoading = false.obs;
  final settings = Rxn<NotificationSettingsModel>();

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;

      final res = await client.getRequest(
        ApiUrls.getNotificationSettings,
      );

      if (res.isSuccess && res.responseData?['data'] != null) {
        settings.value = NotificationSettingsModel.fromJson(
          res.responseData!['data'],
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveSettings() async {
    if (settings.value == null) return;

    isLoading.value = true;

    final res = await client.patchRequest(
      ApiUrls.updateNotificationSettings,
      body: settings.value!.toJson(),
    );

    isLoading.value = false;

    Get.snackbar(
      'Status',
      res.isSuccess
          ? 'Notification settings updated successfully'
          : 'Failed to update settings',
      backgroundColor: res.isSuccess ? Colors.green : Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleSms(bool value) {
    if (settings.value != null) {
      settings.value = settings.value!.copyWith(smsUpdates: value);
    }
  }

  void toggleLocation(bool value) {
    if (settings.value != null) {
      settings.value = settings.value!.copyWith(allowLocation: value);
    }
  }

  void togglePush(bool value) {
    if (settings.value != null) {
      settings.value = settings.value!.copyWith(pushNotification: value);
    }
  }

  void toggleBirthday(bool value) {
    if (settings.value != null) {
      settings.value = settings.value!.copyWith(birthdayRewards: value);
    }
  }
}

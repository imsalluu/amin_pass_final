import 'package:amin_pass/app/urls.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:amin_pass/home/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final NetworkClient _client = Get.find<NetworkClient>();

  final isLoading = false.obs;
  final notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _client.getRequest(ApiUrls.getNotification);

      if (response.isSuccess == true) {
        final Map<String, dynamic>? resData = response.responseData is Map ? response.responseData as Map<String, dynamic> : null;
        if (resData != null) {
          final model = NotificationModel.fromJson(resData);
          if (model.data != null) {
            notifications.assignAll(model.data!);
            debugPrint('✅ NotificationController: Fetched ${notifications.length} notifications');
          }
        } else {
          debugPrint('⚠️ NotificationController: Response data is not a Map: ${response.responseData}');
        }
      } else {
        debugPrint('❌ NotificationController Error: ${response.errorMassage}');
      }
    } catch (e) {
      debugPrint('❌ NotificationController Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

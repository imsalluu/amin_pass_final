import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amin_pass/app/urls.dart';
import 'package:amin_pass/core/services/network/network_client.dart';

class ProfileController extends GetxController {
  final NetworkClient _client = Get.find<NetworkClient>();
  final isLoading = false.obs;

  final id = ''.obs;
  final name = ''.obs;
  final email = ''.obs;
  final avatarUrl = ''.obs;
  final rewardPoints = 0.obs;

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      debugPrint('🔍 ProfileController: Fetching profile...');

      final response = await _client.getRequest(ApiUrls.myProfile);
      debugPrint('📡 ProfileController: Response code: ${response.statusCode}, isSuccess: ${response.isSuccess}');

      if (response.isSuccess == true) {
        final Map? resData = response.responseData is Map ? response.responseData as Map : null;
        
        Map? data;
        if (resData != null) {
          if (resData['data'] is Map) {
            data = resData['data'] as Map;
          } else if (resData['user'] is Map) {
            data = resData['user'] as Map;
          } else {
            data = resData;
          }
        }
            
        debugPrint('📦 ProfileController: Extracted Data: $data');

        if (data != null) {
          id.value = (data['id'] ?? data['_id'] ?? data['customerId'] ?? '').toString();
          name.value = (data['name'] ?? data['fullName'] ?? data['first_name'] ?? '').toString();
          email.value = (data['email'] ?? data['email_address'] ?? '').toString();
          rewardPoints.value = int.tryParse((data['rewardPoints'] ?? data['points'] ?? '0').toString()) ?? 0;

          String rawAvatar = (data['avatarUrl'] ?? data['avatar'] ?? data['profile_image'] ?? data['image'] ?? '').toString();
          if (rawAvatar.isNotEmpty && !rawAvatar.startsWith('http')) {
            avatarUrl.value = "${ApiUrls.mediaBaseUrl}$rawAvatar";
          } else {
            avatarUrl.value = rawAvatar;
          }
          debugPrint('✅ ProfileController: Profile updated - Name: ${name.value}, Email: ${email.value}, Points: ${rewardPoints.value}');
        }
      } else {
        debugPrint('❌ ProfileController: Error - ${response.errorMassage}');
      }
    } catch (e, stack) {
      debugPrint('❌ ProfileController Exception: $e');
      debugPrint('Stacktrace: $stack');
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    id.value = '';
    name.value = '';
    email.value = '';
    avatarUrl.value = '';
    rewardPoints.value = 0;
  }
}
